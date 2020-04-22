Class {
	#name : #GtJSImporter,
	#superclass : #JSProgramNodeVisitor,
	#instVars : [
		'model',
		'directory',
		'files',
		'modules',
		'classes',
		'properties',
		'scopeStack',
		'currentModule',
		'variableReferences',
		'callExpressions',
		'assignmentExpressions'
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
								ifFalse: [ (function parameters at: i) addRValueEntity: each ] ] ] ].
	^ changed
]

{ #category : #'private-model' }
GtJSImporter >> addVariablesInToLocalScope: aNode [
	aNode variables
		do: [ :each | 
			| var name |
			name := each variable source.
			var := scopeStack size = 1
				ifTrue: [ self ensureGlobalNamed: name ]
				ifFalse: [ self ensureLocalVariableNamed: name ].
			var sourceAnchor: (self sourceAnchorFor: each).
			each equalToken notNil
				ifTrue: [ assignmentExpressions add: each -> self currentScope.
					FAMIXAccess new
						from: self currentScope;
						to: var;
						isWrite: true;
						sourceAnchor: var sourceAnchor ] ]
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

{ #category : #'private-model' }
GtJSImporter >> createCommentsFrom: aModule [
	aModule comments
		do: [ :each | 
			self currentScope
				addComment:
					(model
						add:
							(FAMIXComment new
								sourceAnchor:
									(FAMIXIndexedFileAnchor
										fileName: aModule filename pathString
										startPos: each first
										endPos: each last
										model: model);
								yourself)) ]
]

{ #category : #'private-model' }
GtJSImporter >> createPropertyFromDefinition: propertyDefinition [
	| property |
	property := self ensurePropertyNamed: propertyDefinition name source.
	FAMIXAccess new
		from: self currentScope;
		to: property;
		isWrite: true;
		sourceAnchor: (self sourceAnchorFor: propertyDefinition)
]

{ #category : #'private-model' }
GtJSImporter >> createScriptFrom: moduleNode [
	| script relativeName |
	relativeName := self relativeNameFor: moduleNode includeExtension: true.
	script := GtJSScript new name: relativeName.
	model add: script.
	script sourceAnchor: (self sourceAnchorFor: moduleNode).
	files at: moduleNode filename put: script.
	scopeStack := OrderedCollection with: script
]

{ #category : #private }
GtJSImporter >> currentScope [
	^ scopeStack last
]

{ #category : #'private-model' }
GtJSImporter >> ensureFunctionNamed: aString for: aNode around: aBlock [
	| function implicitVar start stop |
	function := FAMIXFunction new name: aString.
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
								ifFalse: [ '' ]) , (s asString copyFrom: start to: stop)
						,
							(aNode left isNil
								ifTrue: [ ')' ]
								ifFalse: [ '' ]) ]).
	model add: function.
	aNode attributeNamed: #modelObject put: function.
	function sourceAnchor: (self sourceAnchorFor: aNode).
	aNode parameters
		do: [ :each | 
			| parm |
			parm := FAMIXParameter new
				name: each variable source;
				sourceAnchor: (self sourceAnchorFor: each);
				yourself.
			model add: parm.
			function addParameter: parm ].
	implicitVar := FAMIXImplicitVariable new name: 'this'.
	model add: implicitVar.
	function addImplicitVariable: implicitVar.
	implicitVar := FAMIXImplicitVariable new name: 'arguments'.
	model add: implicitVar.
	function addImplicitVariable: implicitVar.
	self currentScope addFunction: function.
	self assignScope: function around: aBlock.
	^ function
]

{ #category : #'private-model' }
GtJSImporter >> ensureGlobalNamed: name [
	^ model allGlobalVariables detect: [ :each | each name = name ] ifNone: [ model add: (FAMIXGlobalVariable new name: name) ]
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
	^ self currentScope localVariables
		detect: [ :each | each name = name ]
		ifNone: [ | var |
			var := FAMIXLocalVariable new name: name.
			self currentScope addLocalVariable: var.
			model add: var.
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
	[ var := currentScope localVariables
		detect: [ :each | each name = name ]
		ifNone: [ currentScope parameters
				detect: [ :each | each name = name ]
				ifNone: [ currentScope implicitVariables detect: [ :each | each name = name ] ifNone: [  ] ] ].
	(var isNil and: [ currentScope isJSScript ])
		ifTrue: [ var := self ensureGlobalNamed: name ].
	var isNil ] whileTrue: [ currentScope := currentScope container ].
	^ var
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
	self importSourceDirectory: aDirectory.
	self finishImport
]

{ #category : #importing }
GtJSImporter >> importJSFile: aFile [
	| ast |
	self startingImportingFile.
	ast := JSParser parse: aFile asFileReference contents.
	ast filename: aFile.
	self acceptNode: ast.
	self finishImportingFile
]

{ #category : #importing }
GtJSImporter >> importSourceDirectory: aDirectory [
	directory := aDirectory asFileReference.
	directory fileSystem store isMemoryFileSystem
		ifFalse: [ directory := directory absolutePath ].
	(JSParser sourceFilesIn: directory) do: [ :each | self importJSFile: each ] displayingProgress: 'Importing JS Files'
]

{ #category : #initialization }
GtJSImporter >> initialize [
	super initialize.
	model := MooseModel new.
	model sourceLanguage: FAMIXJSSourceLanguage new.
	files := Dictionary new.
	modules := Dictionary new.
	classes := Dictionary new.
	properties := Dictionary new
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
				arguments: (each key arguments collect: [ :arg | self modelObjectFrom: arg in: each value ]);
				sourceAnchor: (self sourceAnchorFor: each key).
			receiver := each key expression.
			receiver isFunction
				ifTrue: [ (receiver attributeNamed: #modelObject) ifNotNil: [ :func | invocation addCandidate: func ] ]
				ifFalse: [ invocation receiver: (self modelObjectFrom: receiver in: each value) ].
			model add: invocation ]
]

{ #category : #'private-model' }
GtJSImporter >> processForIterator: aForStatement [
	| name var |
	aForStatement varToken notNil
		ifTrue: [ name := aForStatement variable source.
			var := scopeStack size = 1
				ifTrue: [ self ensureGlobalNamed: name ]
				ifFalse: [ self ensureLocalVariableNamed: name ].
			var sourceAnchor: (self sourceAnchorFor: aForStatement variable) ].
	variableReferences add: aForStatement variable -> self currentScope
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
	^ files detect: [ :each | each name = aString ] ifNone: [  ]
]

{ #category : #'private-model' }
GtJSImporter >> sourceAnchorFor: aNode [
	^ FAMIXIndexedFileAnchor
		fileName: aNode topParent filename pathString
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
	callExpressions add: aCallExpression -> self currentScope.
	super visitCallExpression: aCallExpression
]

{ #category : #visiting }
GtJSImporter >> visitClassExpression: aClassExpression [
	| class |
	class := self ensureJSClassNamed: aClassExpression name source.
	aClassExpression attributeNamed: #modelObject put: class.
	class sourceAnchor: (self sourceAnchorFor: aClassExpression).
	aClassExpression superclass
		ifNotNil: [ :spr | 
			class
				addSuperInheritance:
					(FAMIXInheritance new
						model: model;
						subclass: class;
						superclass: (self ensureJSClassForNode: spr)) ].
	self
		assignScope: class
		around: [ super visitClassExpression: aClassExpression ]
]

{ #category : #visiting }
GtJSImporter >> visitForInStatement: aForInStatement [
	self processForIterator: aForInStatement.
	super visitForInStatement: aForInStatement
]

{ #category : #visiting }
GtJSImporter >> visitForOfStatement: aForOfStatement [
	self processForIterator: aForOfStatement.
	super visitForOfStatement: aForOfStatement
]

{ #category : #visiting }
GtJSImporter >> visitForStatement: aForStatement [
	self addVariablesInToLocalScope: aForStatement.
	super visitForStatement: aForStatement
]

{ #category : #visiting }
GtJSImporter >> visitFunction: aFunction [
	| mooseFunction var |
	var := nil.
	aFunction name notNil
		ifTrue: [ var := self ensureLocalVariableNamed: aFunction name source.
			var sourceAnchor: (self sourceAnchorFor: aFunction name).
			(self processVariableReference: aFunction in: self currentScope)
				isWrite: true ].
	mooseFunction := self
		ensureFunctionNamed: (self functionNameFor: aFunction)
		for: aFunction
		around: [ super visitFunction: aFunction ].
	var notNil
		ifTrue: [ var addPotentialJSFunction: mooseFunction ].
	^ mooseFunction
]

{ #category : #visiting }
GtJSImporter >> visitLexicalDeclaration: aNode [
	aNode bindings
		do: [ :each | 
			| var name |
			name := each variable source.
			var := self ensureLocalVariableNamed: name.
			var sourceAnchor: (self sourceAnchorFor: each).
			each equalToken notNil
				ifTrue: [ assignmentExpressions add: each -> self currentScope.
					FAMIXAccess new
						from: self currentScope;
						to: var;
						isWrite: true;
						sourceAnchor: var sourceAnchor;
						yourself ] ].
	super visitLexicalDeclaration: aNode
]

{ #category : #visiting }
GtJSImporter >> visitMethodDefinition: aMethodDefinition [
	| method implicitVar |
	method := FAMIXMethod new.
	model add: method.
	method name: aMethodDefinition name source.
	method
		signature:
			(aMethodDefinition completeSource
				ifNotNil: [ :s | 
					method name
						,
							(s asString
								copyFrom: aMethodDefinition left startPosition
								to: aMethodDefinition right stopPosition) ]).
	aMethodDefinition attributeNamed: #modelObject put: method.
	method sourceAnchor: (self sourceAnchorFor: aMethodDefinition).
	aMethodDefinition parameters
		do: [ :each | 
			| parm |
			parm := FAMIXParameter new
				name: each variable source;
				sourceAnchor: (self sourceAnchorFor: each);
				yourself.
			model add: parm.
			method addParameter: parm ].
	implicitVar := FAMIXImplicitVariable new name: 'this'.
	implicitVar declaredType: self currentScope.
	model add: implicitVar.
	method addImplicitVariable: implicitVar.
	implicitVar := FAMIXImplicitVariable new name: 'arguments'.
	model add: implicitVar.
	method addImplicitVariable: implicitVar.
	self currentScope addMethod: method.
	self
		assignScope: method
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
		ifTrue: [ variableReferences add: aNameExpression -> self currentScope ].
	super visitNameExpression: aNameExpression
]

{ #category : #visiting }
GtJSImporter >> visitNamedPropertyExpression: aNamedPropertyExpression [
	| property access |
	property := self ensurePropertyNamed: aNamedPropertyExpression name source.
	access := FAMIXAccess new
		from: self currentScope;
		to: property;
		isWrite: aNamedPropertyExpression isAssignedTo;
		sourceAnchor: (self sourceAnchorFor: aNamedPropertyExpression).
	model add: access.
	super visitNamedPropertyExpression: aNamedPropertyExpression
]

{ #category : #visiting }
GtJSImporter >> visitObjectLiteral: anObjectLiteral [
	anObjectLiteral definitions do: [ :each | self createPropertyFromDefinition: each ].
	super visitObjectLiteral: anObjectLiteral
]

{ #category : #visiting }
GtJSImporter >> visitPropertyAssignment: aNode [
	aNode value isFunction
		ifTrue: [ ^ (self ensurePropertyNamed: aNode name source) addPotentialJSFunction: (aNode value acceptVisitor: self) ].
	super visitPropertyAssignment: aNode
]

{ #category : #visiting }
GtJSImporter >> visitTryStatement: aTryStatement [
	| var name |
	aTryStatement exceptionType notNil
		ifTrue: [ name := aTryStatement exceptionType source.
			var := self ensureLocalVariableNamed: name.
			var sourceAnchor: (self sourceAnchorFor: aTryStatement exceptionType).
			(self processVariableReference: aTryStatement exceptionType in: self currentScope) isWrite: true ].
	super visitTryStatement: aTryStatement
]

{ #category : #visiting }
GtJSImporter >> visitVariableStatement: aNode [
	self addVariablesInToLocalScope: aNode.
	super visitVariableStatement: aNode
]
