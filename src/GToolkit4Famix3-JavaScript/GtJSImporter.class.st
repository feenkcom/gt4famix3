Class {
	#name : #GtJSImporter,
	#superclass : #JSProgramNodeVisitor,
	#instVars : [
		'model',
		'directory',
		'folders',
		'currentFile',
		'files',
		'scripts',
		'modules',
		'classes',
		'globals',
		'properties',
		'scopeStack',
		'variableReferences',
		'callExpressions',
		'assignmentExpressions',
		'parserClass'
	],
	#category : #'GToolkit4Famix3-JavaScript-Importer'
}

{ #category : #private }
GtJSImporter >> addCandidate: function to: anInvocation [
	| changed |
	(anInvocation candidates includes: function)
		ifTrue: [ ^ false ].
	changed := false.
	anInvocation addCandidate: function.
	anInvocation arguments
		withIndexDo: [ :each :i | 
			each notNil
				ifTrue: [ function parameters size >= i
						ifTrue: [ each isFunction
								ifTrue: [ (function parameters at: i) addPotentialJSFunction: each ]
								ifFalse: [ each isMethod
										ifFalse: [ (function parameters at: i) addRValueEntity: each ] ] ] ] ].
	^ changed
]

{ #category : #'private-model' }
GtJSImporter >> assignScope: modelObject around: aBlock [
	scopeStack addLast: modelObject.
	aBlock
		ensure: [ scopeStack removeLast ]
]

{ #category : #accessing }
GtJSImporter >> classNamed: aString [
	^ classes at: aString ifAbsent: [  ]
]

{ #category : #private }
GtJSImporter >> codeScope [
	scopeStack
		reverseDo: [ :each | 
			(self isCodeItem: each)
				ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : #'private-model' }
GtJSImporter >> createCommentsFrom: aModule [
	aModule comments
		do: [ :each | 
			| comment |
			comment := FAMIXComment new
				sourceAnchor:
					(FAMIXIndexedFileEntityAnchor
						file: currentFile
						startPos: each first
						endPos: each last
						model: model);
				yourself.
			self currentScope addComment: comment.
			model add: comment.
			currentFile addEntity: comment ]
]

{ #category : #'private-model' }
GtJSImporter >> createPropertyFromDefinition: propertyDefinition [
	| property access |
	property := self ensurePropertyNamed: propertyDefinition name source.
	access := FAMIXAccess new
		from: self codeScope;
		to: property;
		isWrite: true;
		sourceAnchor: (self sourceAnchorFor: propertyDefinition).
	model add: access.
	currentFile addEntity: access
]

{ #category : #'private-model' }
GtJSImporter >> createScriptFrom: moduleNode [
	| script relativeName |
	relativeName := self
		relativeNameFor: moduleNode
		includeExtension: true.
	currentFile := self
		ensureFileNamed: moduleNode topParent filename asFileReference.
	script := GtJSScript new name: relativeName.
	model add: script.
	script sourceAnchor: (self sourceAnchorFor: moduleNode).
	currentFile addEntity: script.
	currentFile script: script.
	script module: currentFile.
	scripts add: script.
	scopeStack := OrderedCollection with: script
]

{ #category : #private }
GtJSImporter >> currentScope [
	^ scopeStack last
]

{ #category : #'private-model' }
GtJSImporter >> ensureFileNamed: aFileReference [
	| filename |
	filename := aFileReference pathString.
	DiskStore activeClass isCaseSensitive
		ifFalse: [ filename := filename asUppercase ].
	^ files
		at: filename
		ifAbsentPut: [ | file |
			file := GtJSModule new.
			file name: aFileReference basename.
			aFileReference exists
				ifTrue: [ | encoding anchor |
					encoding := [ aFileReference
						binaryReadStreamDo: [ :in | (ZnCharacterEncoder detectEncoding: in upToEnd) identifier ] ]
						on: ZnCharacterEncodingError
						do: [ :ex | ex return: 'utf-8' ].
					anchor := FAMIXIndexedFileEntityAnchor
						file: file
						startPos: 1
						endPos:
							(aFileReference
								readStreamEncoded: encoding
								do: [ :stream | stream contents size ])
						model: model.
					file sourceAnchor: anchor ]
				ifFalse: [ file isStub: true ].
			(self ensureFolderNamed: aFileReference parent)
				ifNotNil: [ :folder | folder addChildFileSystemEntity: file ].
			model add: file.
			file ]
]

{ #category : #'private-model' }
GtJSImporter >> ensureFolderNamed: aFileReference [
	^ folders
		at: aFileReference pathString
		ifAbsentPut: [ | folder |
			folder := FAMIXFolder new.
			aFileReference = model rootFolder
				ifTrue: [ folder name: '.' ]
				ifFalse: [ folder name: aFileReference basename.
					(self ensureFolderNamed: aFileReference parent)
						ifNotNil: [ :outer | outer addChildFileSystemEntity: folder ] ].
			model add: folder.
			folder ]
]

{ #category : #'private-model' }
GtJSImporter >> ensureFunctionNamed: aString for: aNode around: aBlock [
	| function implicitVar start stop isMethod |
	isMethod := (self isCodeItem: self currentScope) not.
	function := (self functionClassFor: aNode) new name: aString.
	aNode left isNil
		ifTrue: [ start := aNode parameters first startPosition.
			stop := aNode parameters last stopPosition ]
		ifFalse: [ start := aNode left startPosition.
			stop := aNode right stopPosition ].
	function
		signature:
			(aNode completeSource
				ifNotNil: [ :s | 
					function name
						,
							(aNode left isNil
								ifTrue: [ '(' ]
								ifFalse: [ '' ]) , (s copyFrom: start to: stop) asString
						,
							(aNode left isNil
								ifTrue: [ ')' ]
								ifFalse: [ '' ]) ]).
	model add: function.
	currentFile addEntity: function.
	aNode attributeNamed: #modelObject put: function.
	function sourceAnchor: (self sourceAnchorFor: aNode).
	(aNode isKindOf: JSArrowFunctionNode)
		ifFalse: [ implicitVar := FAMIXImplicitVariable new name: 'this'.
			model add: implicitVar.
			function addImplicitVariable: implicitVar.
			implicitVar := FAMIXImplicitVariable new name: 'arguments'.
			model add: implicitVar.
			function addImplicitVariable: implicitVar ].
	isMethod
		ifTrue: [ self currentScope addMethod: function ]
		ifFalse: [ self currentScope addFunction: function ].
	self assignScope: function around: aBlock.
	^ function
]

{ #category : #'private-model' }
GtJSImporter >> ensureGlobalNamed: name [
	^ globals
		at: name
		ifAbsentPut: [ model add: (FAMIXGlobalVariable new name: name) ]
]

{ #category : #'private-model' }
GtJSImporter >> ensureJSClassForNode: aNode [
	^ self ensureJSClassNamed: aNode source
]

{ #category : #'private-model' }
GtJSImporter >> ensureJSClassNamed: aString [
	^ classes at: aString ifAbsentPut: [ model add: (GtJSClass new name: aString) ]
]

{ #category : #'private-model' }
GtJSImporter >> ensureLocalVariableNamed: name [
	^ self codeScope localVariables
		detect: [ :each | each name = name ]
		ifNone: [ | var |
			var := FAMIXLocalVariable new name: name.
			self codeScope addLocalVariable: var.
			model add: var.
			currentFile addEntity: var.
			var ]
]

{ #category : #'private-model' }
GtJSImporter >> ensurePropertyNamed: aString [
	^ properties at: aString ifAbsentPut: [ model add: (FAMIXAttribute new name: aString) ]
]

{ #category : #'private-model' }
GtJSImporter >> ensureVariableFor: node in: entity [
	| currentScope name var |
	name := node name source.
	currentScope := entity.
	[ var := (self isCodeItem: currentScope)
		ifTrue: [ currentScope localVariables
				detect: [ :each | each name = name ]
				ifNone: [ currentScope parameters
						detect: [ :each | each name = name ]
						ifNone: [ currentScope implicitVariables
								detect: [ :each | each name = name ]
								ifNone: [  ] ] ] ].
	(var isNil and: [ currentScope isJSScript ])
		ifTrue: [ var := self ensureGlobalNamed: name ].
	var isNil ] whileTrue: [ currentScope := currentScope parentScope ].
	^ var
]

{ #category : #private }
GtJSImporter >> fileFor: aSourcedEntity [
	aSourcedEntity containerFiles do: [ :each | ^ each ].
	^ nil
]

{ #category : #private }
GtJSImporter >> filename: aFileReference matchesAny: patternCollection [
	^ patternCollection
		anySatisfy: [ :each | each match: aFileReference pathString ]
]

{ #category : #importing }
GtJSImporter >> finishImport [
	self hookupPotentialInvocations
]

{ #category : #private }
GtJSImporter >> finishImportingFile [
	self processVariableReferences.
	self processCallExpressions.
	self processAssignmentExpressions
]

{ #category : #'private-model' }
GtJSImporter >> functionClassFor: aFunctionNode [
	^ (self isCodeItem: self currentScope)
		ifTrue: [ FAMIXFunction ]
		ifFalse: [ FAMIXMethod ]
]

{ #category : #'private-model' }
GtJSImporter >> functionNameFor: aFunction [
	^ (self variableNameForFunction: aFunction)
		ifNil: [ (self propertyNameForFunction: aFunction) ifNil: [ 'anonymous ' , aFunction startPosition printString ] ]
]

{ #category : #private }
GtJSImporter >> hookupPotentialInvocations [
	| changed |
	changed := true.
	[ changed ]
		whileTrue: [ changed := false.
			model allJSInvocations
				do: [ :each | 
					each receiver notNil
						ifTrue: [ each receiver allPotentialJSFunctionsDo: [ :function | changed := changed | (self addCandidate: function to: each) ] ] ] ]
]

{ #category : #importing }
GtJSImporter >> importDirectory: aDirectory [
	self importDirectory: aDirectory excluding: #()
]

{ #category : #importing }
GtJSImporter >> importDirectory: aDirectory excluding: patternCollection [
	model rootFolder: aDirectory asFileReference.
	self importSourceDirectory: aDirectory excluding: patternCollection.
	self finishImport
]

{ #category : #importing }
GtJSImporter >> importJSFile: aFile [
	| ast |
	self startingImportingFile.
	ast := self parserClass
		parseWithErrors: aFile asFileReference contents.
	ast filename: aFile.
	self acceptNode: ast.
	self finishImportingFile
]

{ #category : #importing }
GtJSImporter >> importSourceDirectory: aDirectory excluding: patternCollection [
	directory := aDirectory asFileReference.
	directory fileSystem store isMemoryFileSystem
		ifFalse: [ directory := directory absolutePath ].
	(self parserClass sourceFilesIn: directory)
		do: [ :each | 
			(self filename: each matchesAny: patternCollection)
				ifFalse: [ self importJSFile: each ] ]
		displayingProgress: 'Importing JS Files'
]

{ #category : #initialization }
GtJSImporter >> initialize [
	super initialize.
	model := MooseModel new.
	model sourceLanguage: FAMIXJSSourceLanguage new.
	folders := Dictionary new.
	files := Dictionary new.
	scripts := OrderedCollection new.
	modules := Dictionary new.
	classes := Dictionary new.
	globals := Dictionary new.
	properties := Dictionary new
]

{ #category : #private }
GtJSImporter >> isCodeItem: each [
	^ (each isKindOf: FAMIXType) not
]

{ #category : #private }
GtJSImporter >> isParameter: aNode [
	| current previous |
	current := aNode.
	[ previous := current.
	current := current parent.
	current isNil
		ifTrue: [ ^ false ].
	(current isKindOf: JSFunctionNode)
		or: [ (current isKindOf: JSArrowFunctionNode)
				or: [ current isKindOf: JSMethodDefinitionNode ] ] ] whileFalse.
	^ current parameters identityIncludes: previous
]

{ #category : #private }
GtJSImporter >> localFilename: aString from: aNode [
	| currentDirectory name |
	currentDirectory := aNode topParent filename asFileReference parent.
	name := (aString substrings: '/\')
		inject: currentDirectory
		into: [ :sum :each | 
			each = '..'
				ifTrue: [ sum parent ]
				ifFalse: [ sum / each ] ].
	name exists
		ifTrue: [ ^ name ].
	name := name parent / (name basename , '.js').
	name exists
		ifTrue: [ ^ name ].
	^ nil
]

{ #category : #accessing }
GtJSImporter >> model [
	^ model
]

{ #category : #private }
GtJSImporter >> modelObjectFrom: aNode in: aScope [
	(aNode isKindOf: JSNameExpressionNode)
		ifTrue: [ ^ self ensureVariableFor: aNode in: aScope ].
	(aNode isKindOf: JSNamedPropertyExpressionNode)
		ifTrue: [ ^ self ensurePropertyNamed: aNode name source ].
	((aNode isKindOf: JSFunctionNode) or: [ aNode isKindOf: JSArrowFunctionNode ])
		ifTrue: [ ^ aNode attributeNamed: #modelObject ifAbsent: [ nil ] ].
	^ nil
]

{ #category : #accessing }
GtJSImporter >> moduleNamed: aString [
	^ modules at: aString ifAbsent: [  ]
]

{ #category : #private }
GtJSImporter >> parameterClassFor: aVariableDeclaration [
	^ (aVariableDeclaration parent isKindOf: JSObjectBindingPatternNode)
		ifTrue: [ GtJSObjectBindingParameter ]
		ifFalse: [ FAMIXParameter ]
]

{ #category : #accessing }
GtJSImporter >> parserClass [
	^ parserClass ifNil: [ JSParser ]
]

{ #category : #accessing }
GtJSImporter >> parserClass: aClass [
	parserClass := aClass.
	model sourceLanguage parserClass: aClass
]

{ #category : #private }
GtJSImporter >> processAssignmentExpressions [
	assignmentExpressions do: [ :each | self processAssignmentFrom: each key rhs to: each key lhs in: each value ]
]

{ #category : #private }
GtJSImporter >> processAssignmentFrom: rhsNode to: lhsNode in: aScope [
	| lhsModel rhsModel |
	lhsModel := self modelObjectFrom: lhsNode in: aScope.
	lhsModel isNil
		ifTrue: [ ^ self ].
	rhsModel := self modelObjectFrom: rhsNode in: aScope.
	rhsModel isNil
		ifTrue: [ ^ self ].
	rhsModel isBehaviouralEntity
		ifTrue: [ lhsModel addPotentialJSFunction: rhsModel ]
		ifFalse: [ lhsModel addRValueEntity: rhsModel ]
]

{ #category : #private }
GtJSImporter >> processCallExpressions [
	callExpressions
		do: [ :each | 
			| invocation receiver |
			invocation := GtJSInvocation new
				sender: each value;
				arguments:
					(each key arguments
						collect: [ :arg | self modelObjectFrom: arg in: each value ]);
				sourceAnchor: (self sourceAnchorFor: each key).
			receiver := each key expression.
			receiver isFunction
				ifTrue: [ (receiver attributeNamed: #modelObject)
						ifNotNil: [ :func | invocation addCandidate: func ] ]
				ifFalse:
					[ invocation receiver: (self modelObjectFrom: receiver in: each value) ].
			model add: invocation.
			(self fileFor: each value)
				ifNotNil: [ :file | file addEntity: invocation ] ]
]

{ #category : #private }
GtJSImporter >> processVariableReference: node in: entity [
	| var access |
	var := self ensureVariableFor: node in: entity.
	access := FAMIXAccess new
		from: entity;
		to: var;
		isWrite: node isAssignedTo;
		sourceAnchor: (self sourceAnchorFor: node).
	model add: access.
	(self fileFor: entity) ifNotNil: [ :file | file addEntity: access ].
	^ access
]

{ #category : #private }
GtJSImporter >> processVariableReferences [
	variableReferences
		do: [ :each | 
			| node entity |
			node := each key.
			entity := each value.
			self processVariableReference: node in: entity ]
]

{ #category : #'private-model' }
GtJSImporter >> propertyNameForFunction: aFunction [
	(aFunction parent isKindOf: JSPropertyAssignmentNode)
		ifTrue: [ ^ aFunction parent name source ].
	((aFunction parent isKindOf: JSAssignmentExpressionNode) and: [ aFunction parent rhs == aFunction ])
		ifTrue: [ (aFunction parent lhs isKindOf: JSNamedPropertyExpressionNode)
				ifTrue: [ ^ aFunction parent lhs name source ] ].
	^ nil
]

{ #category : #accessing }
GtJSImporter >> propertyNamed: aString [
	^ properties at: aString ifAbsent: [  ]
]

{ #category : #private }
GtJSImporter >> relativeNameFor: anAstNode includeExtension: aBoolean [
	| fileReference |
	fileReference := anAstNode topParent filename asFileReference.
	aBoolean
		ifFalse: [ fileReference := fileReference withoutExtension ].
	^ (fileReference relativeTo: directory) printWithDelimiter: $/
]

{ #category : #accessing }
GtJSImporter >> scriptNamed: aString [
	^ scripts detect: [ :each | each name = aString ] ifNone: [  ]
]

{ #category : #'private-model' }
GtJSImporter >> sourceAnchorFor: aNode [
	^ FAMIXIndexedFileEntityAnchor
		file: currentFile
		startPos: aNode startPosition
		endPos: aNode stopPosition
		model: model
]

{ #category : #private }
GtJSImporter >> startingImportingFile [
	variableReferences := OrderedCollection new.
	callExpressions := OrderedCollection new.
	assignmentExpressions := OrderedCollection new
]

{ #category : #'private-model' }
GtJSImporter >> variableNameForFunction: aFunction [
	((aFunction isKindOf: JSFunctionNode) and: [ aFunction name notNil ])
		ifTrue: [ ^ aFunction name source ].
	((aFunction parent isKindOf: JSAssignmentExpressionNode) and: [ aFunction parent rhs == aFunction ])
		ifTrue: [ (aFunction parent lhs isKindOf: JSNameExpressionNode)
				ifTrue: [ ^ aFunction parent lhs source ] ].
	(aFunction parent isKindOf: JSVariableDeclarationNode)
		ifTrue: [ ^ aFunction parent variable source ].
	^ nil
]

{ #category : #visiting }
GtJSImporter >> visitArrowFunction: anArrowFunction [
	^ self
		ensureFunctionNamed: (self functionNameFor: anArrowFunction)
		for: anArrowFunction
		around: [ super visitArrowFunction: anArrowFunction ]
]

{ #category : #visiting }
GtJSImporter >> visitAssignmentExpression: anAssignmentExpression [
	anAssignmentExpression operator source = '='
		ifTrue: [ assignmentExpressions add: anAssignmentExpression -> self currentScope ].
	super visitAssignmentExpression: anAssignmentExpression
]

{ #category : #visiting }
GtJSImporter >> visitCallExpression: aCallExpression [
	callExpressions add: aCallExpression -> self codeScope.
	super visitCallExpression: aCallExpression
]

{ #category : #visiting }
GtJSImporter >> visitClassExpression: aClassExpression [
	| class name |
	name := aClassExpression name isNil
		ifTrue: [ 'anonymous ' , aClassExpression startPosition printString ]
		ifFalse: [ aClassExpression name source ].
	class := self ensureJSClassNamed: name.
	currentFile addEntity: class.
	aClassExpression attributeNamed: #modelObject put: class.
	class sourceAnchor: (self sourceAnchorFor: aClassExpression).
	aClassExpression superclass
		ifNotNil: [ :spr | 
			| inheritance |
			inheritance := FAMIXInheritance new
				subclass: class;
				superclass: (self ensureJSClassForNode: spr).
			model add: inheritance.
			currentFile addEntity: inheritance.
			inheritance sourceAnchor: (self sourceAnchorFor: spr).
			class addSuperInheritance: inheritance ].
	self currentScope addClass: class.
	self
		assignScope: class
		around: [ super visitClassExpression: aClassExpression ]
]

{ #category : #visiting }
GtJSImporter >> visitFunction: aFunction [
	| mooseFunction var |
	var := nil.
	aFunction name notNil
		ifTrue: [ (self isCodeItem: self currentScope)
				ifTrue: [ var := self ensureLocalVariableNamed: aFunction name source.
					var sourceAnchor: (self sourceAnchorFor: aFunction name).
					(self processVariableReference: aFunction in: self currentScope)
						isWrite: true ] ].
	mooseFunction := self
		ensureFunctionNamed: (self functionNameFor: aFunction)
		for: aFunction
		around: [ super visitFunction: aFunction ].
	var notNil
		ifTrue: [ var addPotentialJSFunction: mooseFunction ].
	^ mooseFunction
]

{ #category : #visiting }
GtJSImporter >> visitImportDeclaration: aNode [
	| import importedFilename importedFile |
	importedFilename := self
		localFilename: aNode from value pharoFromJSString
		from: aNode.
	importedFilename notNil
		ifTrue: [ importedFile := self ensureFileNamed: importedFilename.
			import := GtJSImport new.
			import source: currentFile.
			import target: importedFile.
			model add: import.
			import sourceAnchor: (self sourceAnchorFor: aNode) ].
	^ super visitImportDeclaration: aNode
]

{ #category : #visiting }
GtJSImporter >> visitMethodDefinition: aMethodDefinition [
	self
		ensureFunctionNamed: aMethodDefinition name source
		for: aMethodDefinition
		around: [ super visitMethodDefinition: aMethodDefinition ]
]

{ #category : #visiting }
GtJSImporter >> visitModule: aModule [
	self createScriptFrom: aModule.
	self createCommentsFrom: aModule.
	super visitModule: aModule
]

{ #category : #visiting }
GtJSImporter >> visitNameExpression: aNameExpression [
	aNameExpression isVariableReference
		ifTrue: [ variableReferences add: aNameExpression -> self codeScope ].
	super visitNameExpression: aNameExpression
]

{ #category : #visiting }
GtJSImporter >> visitNamedPropertyExpression: aNamedPropertyExpression [
	| property access |
	property := self
		ensurePropertyNamed: aNamedPropertyExpression name source.
	access := FAMIXAccess new
		from: self codeScope;
		to: property;
		isWrite: aNamedPropertyExpression isAssignedTo;
		sourceAnchor: (self sourceAnchorFor: aNamedPropertyExpression).
	model add: access.
	currentFile addEntity: access.
	super visitNamedPropertyExpression: aNamedPropertyExpression
]

{ #category : #visiting }
GtJSImporter >> visitObjectLiteral: anObjectLiteral [
	| object |
	object := GtJSObject new.
	object
		name:
			'{' , anObjectLiteral startPosition printString , ':'
				, anObjectLiteral stopPosition printString , '}'.
	model add: object.
	currentFile addEntity: object.
	object sourceAnchor: (self sourceAnchorFor: anObjectLiteral).
	anObjectLiteral definitions
		do: [ :each | 
			(each isKindOf: JSNameExpressionNode)
				ifTrue: [ | property access |
					property := self ensurePropertyNamed: each source.
					access := FAMIXAccess new
						from: self codeScope;
						to: property;
						isWrite: true;
						sourceAnchor: (self sourceAnchorFor: each).
					model add: access.
					currentFile addEntity: access ] ].
	self currentScope addType: object.
	self
		assignScope: object
		around: [ super visitObjectLiteral: anObjectLiteral ]
]

{ #category : #visiting }
GtJSImporter >> visitPropertyAssignment: aNode [
	aNode value isFunction
		ifTrue: [ ^ (self ensurePropertyNamed: aNode name source)
				addPotentialJSFunction: (aNode value acceptVisitor: self) ].
	self createPropertyFromDefinition: aNode.
	super visitPropertyAssignment: aNode
]

{ #category : #visiting }
GtJSImporter >> visitTryStatement: aTryStatement [
	| var name |
	aTryStatement exceptionType notNil
		ifTrue: [ name := aTryStatement exceptionType source.
			var := self ensureLocalVariableNamed: name.
			var
				sourceAnchor: (self sourceAnchorFor: aTryStatement exceptionType).
			(self
				processVariableReference: aTryStatement exceptionType
				in: self currentScope) isWrite: true ].
	super visitTryStatement: aTryStatement
]

{ #category : #visiting }
GtJSImporter >> visitVariableDeclaration: aVariableDeclaration [
	| var name access parm |
	aVariableDeclaration variable notNil
		ifTrue: [ (self isParameter: aVariableDeclaration)
				ifTrue: [ parm := (self parameterClassFor: aVariableDeclaration) new
						name: aVariableDeclaration variable source;
						sourceAnchor: (self sourceAnchorFor: aVariableDeclaration);
						yourself.
					model add: parm.
					currentFile addEntity: parm.
					self currentScope addParameter: parm ]
				ifFalse: [ name := aVariableDeclaration variable source.
					var := (scopeStack size = 1
						and:
							[ (aVariableDeclaration parent isKindOf: JSLexicalDeclarationNode) not ])
						ifTrue: [ self ensureGlobalNamed: name ]
						ifFalse: [ self ensureLocalVariableNamed: name ].
					var sourceAnchor: (self sourceAnchorFor: aVariableDeclaration).
					aVariableDeclaration equalToken notNil
						ifTrue:
							[ assignmentExpressions add: aVariableDeclaration -> self currentScope.
							access := FAMIXAccess new
								from: self currentScope;
								to: var;
								isWrite: true;
								sourceAnchor: var sourceAnchor;
								yourself.
							model add: access.
							currentFile addEntity: access ] ] ].
	super visitVariableDeclaration: aVariableDeclaration
]
