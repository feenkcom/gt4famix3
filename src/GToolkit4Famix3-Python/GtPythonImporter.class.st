Class {
	#name : #GtPythonImporter,
	#superclass : #PyRootNodeVisitor,
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
		'stringType',
		'numberType',
		'booleanType',
		'includeASTNodes',
		'shouldProcessInvocations',
		'enums',
		'parserClasses',
		'currentSourceLanguage',
		'annotationTypes'
	],
	#category : #'GToolkit4Famix3-Python'
}

{ #category : #'as yet unclassified' }
GtPythonImporter >> assignScope: modelObject around: aBlock [
	scopeStack addLast: modelObject.
	aBlock ensure: [ scopeStack removeLast ]
]

{ #category : #'llm-generated' }
GtPythonImporter >> classes [
	^ classes
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> codeScope [
	scopeStack reverseDo: [ :each | (self isCodeItem: each) ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> contentsOfFile: aFileReference [
	| encoding |
	encoding := [
		aFileReference binaryReadStreamDo: [ :in | (ZnCharacterEncoder detectEncoding: in upToEnd) identifier ]
	] on: Error do: [ nil ].
	^ aFileReference readStreamDo: [ :stream |
		encoding ifNotNil: [ stream encoding: encoding ].
		stream upToEnd ]
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> currentScope [
	^ scopeStack last
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> ensureAnnotationNamed: aString [
	^ annotationTypes
		at: aString
		ifAbsentPut: [ FAMIXAnnotationType new
				name: aString;
				mooseModel: model;
				yourself ]
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> ensureFileNamed: aFileReference [
	| filename file encoding anchor |
	filename := aFileReference pathString.
	DiskStore activeClass isCaseSensitive ifFalse: [ filename := filename asUppercase ].
	^ files at: filename ifAbsentPut: [
		file := FAMIXFile new.
		file name: aFileReference basename.
		(aFileReference exists) ifTrue: [
			encoding := aFileReference size isZero
				ifTrue: [ 'utf-8' ]
				ifFalse: [ [ aFileReference binaryReadStreamDo: [ :in | (ZnCharacterEncoder detectEncoding: in upToEnd) identifier ] ] on: ZnCharacterEncodingError do: [ :ex | ex return: 'utf-8' ] ].
			anchor := FAMIXIndexedFileEntityAnchor
				file: file
				startPos: 1
				endPos: (aFileReference readStreamEncoded: encoding do: [ :stream | stream contents size ])
				model: model.
			file sourceAnchor: anchor.
			currentSourceLanguage ifNotNil: [ file declaredSourceLanguage: currentSourceLanguage ]
		] ifFalse: [ file isStub: true ].
		(self ensureFolderNamed: aFileReference parent) ifNotNil: [ :folder | folder addChildFileSystemEntity: file ].
		model add: file.
		file ]
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> ensureFolderNamed: aFileReference [
	^ folders
		at: aFileReference pathString
		ifAbsentPut: [ | folder |
			folder := FAMIXFolder new.
			aFileReference = model rootFolder asFileReference
				ifTrue: [ folder name: '.' ]
				ifFalse: [ folder name: aFileReference basename.
					(self ensureFolderNamed: aFileReference parent)
						ifNotNil: [ :outer | outer addChildFileSystemEntity: folder ] ].
			model add: folder.
			folder ]
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> ensureFunctionNamed: aString for: aNode around: aBlock [
	| function isMethod |
	isMethod := (self isCodeItem: self currentScope) not.
	function := (self functionClassFor: aNode) new name: aString.
	model add: function.
	self storeAST: aNode into: function.
	currentFile addEntity: function.
	aNode attributeNamed: #modelObject put: function.
	function sourceAnchor: (self sourceAnchorFor: aNode).
	isMethod
		ifTrue: [ self currentScope addMethod: function ]
		ifFalse: [ (self currentScope respondsTo: #addFunction:) ifTrue: [ self currentScope addFunction: function ] ].
	self assignScope: function around: aBlock.
	^ function
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> ensureGlobalNamed: name [
	^ globals at: name ifAbsentPut: [ model add: (FAMIXGlobalVariable new name: name) ]
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> ensureLocalVariableNamed: name [
	^ self codeScope localVariables
		detect: [ :each | each name = name ]
		ifNone: [ | var |
			var := FAMIXLocalVariable new name: name.
			self codeScope addLocalVariable: var.
			model add: var.
			currentFile addEntity: var.
			var ]
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> ensureModuleScopeForCurrentFile [
	| fun endPos |
	fun := FAMIXFunction new name: '<module>'.
	model add: fun.
	currentFile addEntity: fun.
	endPos := (currentFile sourceAnchor
		ifNotNil: [ :a | a endPos ]
		ifNil: [ 1 ]).
	fun sourceAnchor: (FAMIXIndexedFileEntityAnchor
		file: currentFile
		startPos: 1
		endPos: endPos
		model: model).
	^ fun
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> ensurePropertyNamed: aString [
	^ properties at: aString ifAbsentPut: [ model add: (FAMIXAttribute new name: aString) ]
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> ensureVariableFor: node in: entity [
	| name var |
	name := (node respondsTo: #name)
		ifTrue: [ node name source ]
		ifFalse: [ node source ].
	var := (entity respondsTo: #localVariables)
		ifTrue: [ entity localVariables
				detect: [ :each | each name = name ]
				ifNone: [ (entity respondsTo: #parameters)
					ifTrue: [ entity parameters detect: [ :each | each name = name ] ifNone: [ nil ] ]
					ifFalse: [ nil ] ] ]
		ifFalse: [ nil ].
	^ var ifNil: [ self ensureGlobalNamed: name ]
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> fileFor: aSourcedEntity [
	aSourcedEntity containerFiles do: [ :each | ^ each ].
	^ nil
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> filename: aFileReference matchesAny: patternCollection [
	patternCollection ifNil: [ ^ false ].
	patternCollection isEmpty ifTrue: [ ^ false ].
	^ patternCollection anySatisfy: [ :pattern |
		pattern isString
			ifTrue: [ aFileReference fullName includesSubstring: pattern ]
			ifFalse: [ false ] ]
]

{ #category : #'llm-generated' }
GtPythonImporter >> files [
	^ files
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> finishImport [
	"Hook for post-processing; currently no-op"
	^ self
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> finishImportingFile [
	self processVariableReferences.
	self processCallExpressions.
	self processAssignmentExpressions
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> functionClassFor: aFunctionNode [
	^ (self isCodeItem: self currentScope)
		ifTrue: [ FAMIXFunction ]
		ifFalse: [ FAMIXMethod ]
]

{ #category : #'llm-generated' }
GtPythonImporter >> globals [
	^ globals
]

{ #category : #'llm-generated' }
GtPythonImporter >> gtClassesViewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Classes';
		priority: 2;
		items: [ classes values asArray sort: [ :a :b | a name <= b name ] ];
		column: 'Class' text: #name
]

{ #category : #'llm-generated' }
GtPythonImporter >> gtFilesViewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Files';
		priority: 1;
		items: [ files values asArray sort: [ :a :b | a name <= b name ] ];
		column: 'File' text: #name
]

{ #category : #'llm-generated' }
GtPythonImporter >> gtGlobalsViewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Globals';
		priority: 3;
		items: [ globals values asArray sort: [ :a :b | a name <= b name ] ];
		column: 'Name' text: #name
]

{ #category : #'llm-generated' }
GtPythonImporter >> gtInspectorTitleString [
	^ 'Python Importer — ', files size asString, ' files, ', classes size asString, ' classes'
]

{ #category : #'llm-generated' }
GtPythonImporter >> gtModelFor: aView [
	<gtView>
	^ aView forward
		title: 'Model';
		priority: 5;
		object: [ model ];
		view: #gtNavigationFor:
]

{ #category : #'llm-generated' }
GtPythonImporter >> gtPropertiesViewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Attributes';
		priority: 4;
		items: [ properties values asArray sort: [ :a :b | a name <= b name ] ];
		column: 'Attribute' text: #name
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> importDirectory: aDirectory [
	self importDirectory: aDirectory excluding: #()
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> importDirectory: aDirectory excluding: patternCollection [
	self importSourceDirectory: aDirectory excluding: patternCollection
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> importPythonFile: aFile using: aParserClass [
	| ast moduleScope |
	self startingImportingFile.
	currentFile := self ensureFileNamed: aFile asFileReference.
	ast := aParserClass parseWithErrors: (self contentsOfFile: aFile asFileReference).
	(ast respondsTo: #filename:) ifTrue: [ ast filename: aFile ].
	moduleScope := self ensureModuleScopeForCurrentFile.
	self assignScope: moduleScope around: [ self processPythonAst: ast ].
	self finishImportingFile
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> importSourceDirectory: aDirectory excluding: patternCollection [
	model privateState
		attributeAt: #rootFolder
		ifAbsent: [ model rootFolder: aDirectory ].
	directory := aDirectory asFileReference.
	directory fileSystem store isMemoryFileSystem
		ifFalse: [ directory := directory absolutePath asFileReference ].
	self parserClasses
		do: [ :class |
			currentSourceLanguage := FAMIXPythonSourceLanguage new.
			(self pythonSourceFilesIn: directory)
				do: [ :each |
					(self filename: each matchesAny: patternCollection)
						ifFalse: [ self importPythonFile: each using: class ] ] ]
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> initialize [
	super initialize.
	model := MooseModel new.
	model sourceLanguage: FAMIXPythonSourceLanguage new.
	includeASTNodes := true.
	folders := Dictionary new.
	files := Dictionary new.
	scripts := OrderedCollection new.
	annotationTypes := Dictionary new.
	scopeStack := OrderedCollection new.
	self resetForNewPackage
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> isCodeItem: each [
	^ (each isKindOf: FAMIXType) not
]

{ #category : #'llm-generated' }
GtPythonImporter >> model [
	^ model
]

{ #category : #accessing }
GtPythonImporter >> model: anObject [
	model := anObject
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> modelObjectFrom: aNode in: aScope [
	(aNode isKindOf: PyVariableExpressionNode) ifTrue: [ ^ self ensureVariableFor: aNode in: aScope ].
	(aNode isKindOf: PyFieldAccessExpressionNode) ifTrue: [ ^ self ensurePropertyNamed: ((aNode respondsTo: #name) ifTrue: [ aNode name source ] ifFalse: [ aNode source ]) ].
	((aNode isKindOf: PyFunctionDefinitionNode) or: [ aNode isKindOf: PyLambdaExpressionNode ]) ifTrue: [ ^ aNode attributeNamed: #modelObject ifAbsent: [ nil ] ].
	^ nil
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> parserClasses [
	^ parserClasses ifNil: [ { PythonParser } ]
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> parserClasses: aCollection [
	parserClasses := aCollection
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> processAssignmentExpressions [
	"Hook: implement when we map Python LHS/RHS shapes precisely"
	^ self
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> processCallExpressions [
	callExpressions do: [ :each |
		| call scope invocation callee args |
		call := each key.
		scope := each value.
		invocation := FAMIXInvocation new
			sender: scope;
			sourceAnchor: (self sourceAnchorFor: call).
		args := (call respondsTo: #arguments)
			ifTrue: [ call arguments collect: [ :arg | self modelObjectFrom: arg in: scope ] ]
			ifFalse: [ #() ].
		invocation propertyNamed: #arguments put: args.
		callee := self pythonCalleeOf: call.
		callee ifNotNil: [
			(callee attributeNamed: #modelObject ifAbsent: [ nil ])
				ifNotNil: [ :func | invocation addCandidate: func ]
				ifNil: [ invocation receiver: (self modelObjectFrom: callee in: scope) ] ].
		model add: invocation.
		self storeAST: call into: invocation.
		(self fileFor: scope) ifNotNil: [ :file | file addEntity: invocation ] ]
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> processPythonAst: ast [
	self acceptNode: ast
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> processVariableReferences [
	variableReferences do: [ :each |
		| node entity |
		node := each key.
		entity := each value.
		(entity isKindOf: FAMIXBehaviouralEntity) ifTrue: [ | access target |
			target := self ensureVariableFor: node in: entity.
			access := FAMIXAccess new
				from: entity;
				to: target;
				isWrite: (self pythonIsAssigned: node);
				sourceAnchor: (self sourceAnchorFor: node).
			model add: access.
			self storeAST: node into: access.
			(self fileFor: entity) ifNotNil: [ :file | file addEntity: access ] ] ]
]

{ #category : #'llm-generated' }
GtPythonImporter >> properties [
	^ properties
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> pythonCalleeOf: aCall [
	(aCall respondsTo: #expression) ifTrue: [ ^ aCall expression ].
	(aCall respondsTo: #function) ifTrue: [ ^ aCall function ].
	(aCall respondsTo: #receiver) ifTrue: [ ^ aCall receiver ].
	^ nil
]

{ #category : #'llm-generated' }
GtPythonImporter >> pythonClassNameFor: aClassDefinition [
	^ ((self pythonFirstNameChildSourceOf: aClassDefinition)
		ifNil: [ self pythonNameFromHeaderOf: aClassDefinition withKeyword: 'class' ])
		ifNil: [ 'anonymous ' , aClassDefinition startPosition printString ]
]

{ #category : #'llm-generated' }
GtPythonImporter >> pythonFirstNameChildSourceOf: aNode [
	| nameNode |
	nameNode := aNode children
			detect: [ :each | 
				((each isKindOf: PyNameNode) or: [ each isKindOf: PyRelativeNameNode ])
					or: [ each isKindOf: PyVariableExpressionNode ] ]
			ifNone: [ nil ].
	^ nameNode ifNotNil: [ nameNode source ]
]

{ #category : #'llm-generated' }
GtPythonImporter >> pythonFunctionNameFor: aFunctionDefinition [
	^ ((self pythonFirstNameChildSourceOf: aFunctionDefinition)
		ifNil: [ self pythonNameFromHeaderOf: aFunctionDefinition withKeyword: 'def' ])
		ifNil: [ 'anonymous ' , aFunctionDefinition startPosition printString ]
]

{ #category : #'llm-generated' }
GtPythonImporter >> pythonIdentifierChar: aChar [
	^ aChar isAlphaNumeric or: [ aChar = $_ ]
]

{ #category : #'llm-generated' }
GtPythonImporter >> pythonIdentifierStartChar: aChar [
	^ aChar isLetter or: [ aChar = $_ ]
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> pythonIsAssigned: aVarNode [
	| p |
	p := aVarNode parent.
	^ p notNil and: [ (p class name includesSubstring: 'Assignment') ]
]

{ #category : #'llm-generated' }
GtPythonImporter >> pythonNameFromHeaderOf: aNode withKeyword: aKeyword [
	| text idx nameStart nameEnd |
	text := (aNode completeSource
		ifNotNil: [ :s | (s copyFrom: aNode startPosition to: aNode stopPosition) asString ]
		ifNil: [ '' ]).
	idx := text findString: aKeyword startingAt: 1.
	idx = 0 ifTrue: [ ^ nil ].
	nameStart := self pythonSkipSpacesIn: text from: idx + aKeyword size.
	(nameStart <= text size and: [ self pythonIdentifierStartChar: (text at: nameStart) ]) ifFalse: [ ^ nil ].
	nameEnd := nameStart.
	[ nameEnd < text size and: [ self pythonIdentifierChar: (text at: nameEnd + 1) ] ] whileTrue: [ nameEnd := nameEnd + 1 ].
	^ text copyFrom: nameStart to: nameEnd
]

{ #category : #'llm-generated' }
GtPythonImporter >> pythonSkipSpacesIn: text from: index [
	| i |
	i := index.
	[ i <= text size and: [ (text at: i) asciiValue <= 32 ] ] whileTrue: [ i := i + 1 ].
	^ i
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> pythonSourceFilesIn: aDirectory [
	| all |
	all := aDirectory allChildren.
	^ all select: [ :each |
		each isFile and: [ | ext |
			ext := each extension ifNil: [ '' ].
			#('py' 'pyi') includes: ext asLowercase ] ]
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> resetForNewPackage [
	modules := Dictionary new.
	classes := Dictionary new.
	globals := Dictionary new.
	properties := Dictionary new.
	enums := Dictionary new
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> sourceAnchorFor: aNode [
	^ FAMIXIndexedFileEntityAnchor
		file: currentFile
		startPos: aNode startPosition
		endPos: aNode stopPosition
		model: model
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> startingImportingFile [
	variableReferences := OrderedCollection new.
	callExpressions := OrderedCollection new.
	assignmentExpressions := OrderedCollection new
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> storeAST: aNode into: anEntity [
	includeASTNodes ifTrue: [ anEntity propertyNamed: #ast put: aNode ]
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> visitAssignmentExpression: anAssignmentExpression [
	assignmentExpressions add: anAssignmentExpression -> self currentScope.
	^ super visitAssignmentExpression: anAssignmentExpression
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> visitAssignmentStatement: anAssignmentStatement [
	assignmentExpressions add: anAssignmentStatement -> self currentScope.
	^ super visitAssignmentStatement: anAssignmentStatement
]

{ #category : #'llm-generated' }
GtPythonImporter >> visitClassDefinition: aNode [
	| name clazz |
	name := self pythonClassNameFor: aNode.
	clazz := classes at: name ifAbsentPut: [ | c | c := FAMIXClass new name: name. model add: c. currentFile addEntity: c. c ].
	self storeAST: aNode into: clazz.
	clazz sourceAnchor: (self sourceAnchorFor: aNode).
	self assignScope: clazz around: [ super visitClassDefinition: aNode ].
	^ clazz
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> visitFile: aNode [
	"Do not override currentFile here; it's a FAMIXFile set in importPythonFile:."
	^ super visitFile: aNode
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> visitFile_input: aNode [
	^ self visitSmaCCParseNode: aNode
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> visitFunctionCallExpression: aCall [
	callExpressions add: aCall -> self codeScope.
	^ super visitFunctionCallExpression: aCall
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> visitFunctionDefinition: aFunctionDefinition [
	^ self
		ensureFunctionNamed: (self pythonFunctionNameFor: aFunctionDefinition)
		for: aFunctionDefinition
		around: [ super visitFunctionDefinition: aFunctionDefinition ]
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> visitImportStatement: aNode [
	"TODO: create module/import entities in the model"
	^ self visitSmaCCParseNode: aNode
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> visitRoot: aNode [
	^ super visitRoot: aNode
]

{ #category : #'as yet unclassified' }
GtPythonImporter >> visitVariableExpression: aVariableExpression [
	variableReferences add: aVariableExpression -> self codeScope.
	^ super visitVariableExpression: aVariableExpression
]
