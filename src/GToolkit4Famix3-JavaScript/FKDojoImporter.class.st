"
allJS := root allFiles select: [ :each | each extension = 'js' ].
asts := allJS collect: [ :each | JSParser parseFile: each  ].


items := OrderedCollection new.
asts do: [ :each | 
	each expressionsMatching: 'declare(`?arg1{beList}`, `?super` , {`?props1{beList}`, templateString: `?templateVariable`, `?props2{beList}`})' 
		do: [ :node :matches | 
			| superDefinition superArray |
			superDefinition := matches at: 'super'.
			superArray := (superDefinition isKindOf: JSArrayLiteralNode) 
				ifFalse: [ superDefinition asArray ]
				ifTrue: [ superDefinition expressions ].
			templateVariableName := matches at: 'templateVariable'.
			function := (templateVariableName parentOfType: JSFunctionNode).
			parameterValues := (function parameters withIndexCollect: [ :param :index | 
	param variable name value -> ((function parentOfType: JSCallExpressionNode) arguments first expressions at: index) asPharoString ]) asDictionary.
			items add: each -> { parameterValues at: templateVariableName name value . superArray collect: [ :superName | parameterValues at: superName name value ] } ].
	].
items collect: #key.



modules := OrderedCollection new.
asts do: [ :each | 
	each expressionsMatching: 'define([`?imports{beList}`], function(`?arg1{beList}`) {return declare(`?name{beList}`, `?super`, `?prototype`)})' 
		do: [ :node :matches | 
			modules add: node 
	] ].
modules.
"
Class {
	#name : #FKDojoImporter,
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
		'patterns',
		'variableReferences',
		'callExpressions',
		'assignmentExpressions'
	],
	#category : #'GToolkit4Famix3-JavaScript-Dojo'
}

{ #category : #visiting }
FKDojoImporter >> acceptNode: aSmaCCParseNode [
	patterns
		do: [ :each | 
			(each execute: aSmaCCParseNode)
				ifTrue: [ ^ self ] ].
	^ super acceptNode: aSmaCCParseNode
]

{ #category : #private }
FKDojoImporter >> addCandidate: function to: anInvocation [
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

{ #category : #private }
FKDojoImporter >> addDojoClassPatternFor: aVariableDeclarationNode [
	| patternAsts patternStrings declareName |
	patternStrings := #('<1s>([`?supers{beList}`], { `?props{beList}` })' '<1s>(`?super`, { `?props{beList}` })' '<1s>(`?name`, [`?supers{beList}`], { `?props{beList}` })' '<1s>(`?name`, `?super`, { `?props{beList}` })').
	declareName := aVariableDeclarationNode variable source.
	patternAsts := patternStrings
		inject: OrderedCollection new
		into: [ :sum :each | 
			sum
				addAll: (JSParser parseAndCacheAll: (each expandMacrosWith: declareName) startingAt: JSParser startingStateForExpression);
				yourself ].
	patterns
		add:
			(FKAstPatternRunner
				forPatterns: patternAsts
				do: [ :node :mapping | 
					self
						createDojoClass: node arguments last
						withSupers: (mapping at: 'supers' ifAbsent: [ #() ]) , ((mapping at: 'super' ifAbsent: [  ]) ifNil: [ #() ] ifNotNil: [ :spr | Array with: spr ])
						named:
							(currentModule isNil
								ifTrue: [ 'anonymous' ]
								ifFalse: [ currentModule name ]).
					node acceptVisitor: self ])
]

{ #category : #'private-model' }
FKDojoImporter >> addVariablesInToLocalScope: aNode [
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
FKDojoImporter >> createCommentsFrom: aModule [
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
FKDojoImporter >> createDojoClass: objectNode withSupers: aCollection named: aString [
	| class template |
	class := self ensureDojoClassNamed: aString.
	class sourceAnchor: (self sourceAnchorFor: objectNode parent).
	template := nil.
	objectNode definitions
		do: [ :each | 
			((each isKindOf: JSPropertyAssignmentNode) and: [ each name source = 'templateString' ])
				ifTrue: [ template := each value ] ].
	template notNil
		ifTrue: [ class isWidget: true.
			class template: (self templateStringForNode: template) ].
	aCollection
		do: [ :each | 
			class
				addSuperInheritance:
					(FAMIXInheritance new
						subclass: class;
						superclass: (self ensureDojoClassForNode: each)) ]
]

{ #category : #'private-model' }
FKDojoImporter >> createDojoModule: aNode around: aBlock [
	| declareIndex patternsSize functionParameters |
	declareIndex := 0.
	currentModule := self ensureDojoModuleNamed: (self relativeNameFor: aNode includeExtension: false).
	currentModule sourceAnchor: (self sourceAnchorFor: aNode).
	functionParameters := aNode arguments last parameters.
	aNode arguments first expressions
		keysAndValuesDo: [ :i :each | 
			| prereqName prereqModule |
			prereqName := self moduleNameFrom: each.
			(prereqName endsWith: 'dojo/_base/declare')
				ifTrue: [ declareIndex := i ].
			prereqModule := self ensureDojoModuleNamed: prereqName.
			currentModule addRequiredModule: prereqModule.
			i <= functionParameters size
				ifTrue: [ (aNode attributeNamed: #parameterMapping ifAbsentPut: [ Dictionary new ]) at: (functionParameters at: i) source put: (self fileNameFrom: each) ] ].
	patternsSize := patterns size.
	(declareIndex > 0 and: [ declareIndex <= functionParameters size ])
		ifTrue: [ self addDojoClassPatternFor: (functionParameters at: declareIndex) ].
	aBlock
		ensure: [ [ patternsSize < patterns size ] whileTrue: [ patterns removeLast ].
			currentModule := nil ]
]

{ #category : #'private-model' }
FKDojoImporter >> createPropertyFromDefinition: propertyDefinition [
	| property |
	property := self ensurePropertyNamed: propertyDefinition name source.
	FAMIXAccess new
		from: self currentScope;
		to: property;
		isWrite: true;
		sourceAnchor: (self sourceAnchorFor: propertyDefinition)
]

{ #category : #'private-model' }
FKDojoImporter >> createScriptFrom: moduleNode [
	| script relativeName |
	relativeName := self relativeNameFor: moduleNode includeExtension: true.
	script := FKJSScript new name: relativeName.
	model add: script.
	script sourceAnchor: (self sourceAnchorFor: moduleNode).
	files at: moduleNode filename put: script.
	scopeStack := OrderedCollection with: script
]

{ #category : #private }
FKDojoImporter >> currentScope [
	^ scopeStack last
]

{ #category : #accessing }
FKDojoImporter >> dojoClassNamed: aString [
	^ classes at: aString ifAbsent: [  ]
]

{ #category : #accessing }
FKDojoImporter >> dojoModuleNamed: aString [
	^ modules at: aString ifAbsent: [  ]
]

{ #category : #'private-model' }
FKDojoImporter >> ensureDojoClassForNode: aNode [
	| name |
	(aNode isKindOf: JSNameExpressionNode)
		ifFalse: [ ^ nil ].
	name := self moduleStringFor: aNode name source in: aNode.
	^ self ensureDojoClassNamed: name
]

{ #category : #'private-model' }
FKDojoImporter >> ensureDojoClassNamed: aString [
	| name |
	name := aString copyReplaceAll: '/' with: '.'.
	^ classes at: name ifAbsentPut: [ model add: (FKDojoClass new name: name) ]
]

{ #category : #'private-model' }
FKDojoImporter >> ensureDojoModuleNamed: aString [
	^ modules at: aString ifAbsentPut: [ model add: (FKDojoModule new name: aString) ]
]

{ #category : #'private-model' }
FKDojoImporter >> ensureFunctionNamed: aString for: aNode around: aBlock [
	| function implicitVar start stop |
	function := FAMIXFunction new name: aString.
	aNode left isNil
		ifTrue: [ start := aNode parameters first startPosition.
			stop := aNode parameters last stopPosition ]
		ifFalse: [ start := aNode left startPosition.
			stop := aNode right stopPosition ].
	function signature: (aNode completeSource ifNotNil: [ :s | s asString copyFrom: start to: stop ]).
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
	scopeStack addLast: function.
	aBlock
		ensure: [ scopeStack removeLast ].
	^ function
]

{ #category : #'private-model' }
FKDojoImporter >> ensureGlobalNamed: name [
	^ model allGlobalVariables detect: [ :each | each name = name ] ifNone: [ model add: (FAMIXGlobalVariable new name: name) ]
]

{ #category : #'private-model' }
FKDojoImporter >> ensureLocalVariableNamed: name [
	^ self currentScope localVariables
		detect: [ :each | each name = name ]
		ifNone: [ | var |
			var := FAMIXLocalVariable new name: name.
			self currentScope addLocalVariable: var.
			model add: var.
			var ]
]

{ #category : #'private-model' }
FKDojoImporter >> ensurePropertyNamed: aString [
	^ properties at: aString ifAbsentPut: [ model add: (FAMIXAttribute new name: aString) ]
]

{ #category : #'private-model' }
FKDojoImporter >> ensureVariableFor: node in: entity [
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

{ #category : #private }
FKDojoImporter >> fileNameFrom: aLiteral [
	| name |
	name := aLiteral asPharoString.
	(name includes: $!)
		ifTrue: [ name := name copyFrom: (name indexOf: $!) + 1 to: name size ].
	^ name
]

{ #category : #importing }
FKDojoImporter >> finishImport [
	self hookupPotentialInvocations
]

{ #category : #private }
FKDojoImporter >> finishImportingFile [
	self processVariableReferences.
	self processCallExpressions.
	self processAssignmentExpressions
]

{ #category : #'private-model' }
FKDojoImporter >> functionNameFor: aFunction [
	^ (self variableNameForFunction: aFunction)
		ifNil: [ (self propertyNameForFunction: aFunction) ifNil: [ 'anonymous ' , aFunction startPosition printString ] ]
]

{ #category : #private }
FKDojoImporter >> hookupPotentialInvocations [
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
FKDojoImporter >> importDirectory: aDirectory [
	(aDirectory asFileReference allDirectoriesMatching: 'src')
		do: [ :each | self importSourceDirectory: each ]
		displayingProgress: 'Importing JS Project'.
	self finishImport
]

{ #category : #importing }
FKDojoImporter >> importJSFile: aFile [
	| ast |
	self startingImportingFile.
	ast := JSParser parse: aFile asFileReference contents.
	ast filename: aFile.
	self acceptNode: ast.
	self finishImportingFile
]

{ #category : #importing }
FKDojoImporter >> importSourceDirectory: aDirectory [
	directory := aDirectory asFileReference.
	directory fileSystem store isMemoryFileSystem
		ifFalse: [ directory := directory absolutePath ].
	(JSParser sourceFilesIn: directory) do: [ :each | self importJSFile: each ] displayingProgress: 'Importing JS Files'
]

{ #category : #'initialize-release' }
FKDojoImporter >> initialize [
	model := MooseModel new.
	files := Dictionary new.
	modules := Dictionary new.
	classes := Dictionary new.
	properties := Dictionary new.
	patterns := OrderedCollection new.
	self initializeModulePatterns.
	self initializeClassPatterns
]

{ #category : #private }
FKDojoImporter >> initializeClassPatterns [
	
]

{ #category : #private }
FKDojoImporter >> initializeModulePatterns [
	| patternAsts runner |
	patternAsts := JSParser
		parseAndCacheAll: 'define([`?prereqs{beList}`], function (`?args{beList}`) { `?statements{beList}` })'
		startingAt: JSParser startingStateForExpression.
	runner := FKAstPatternRunner forPatterns: patternAsts do: [ :node | self createDojoModule: node around: [ node acceptVisitor: self ] ].
	patterns add: runner
]

{ #category : #accessing }
FKDojoImporter >> model [
	^ model
]

{ #category : #private }
FKDojoImporter >> modelObjectFrom: aNode in: aScope [
	(aNode isKindOf: JSNameExpressionNode)
		ifTrue: [ ^ self ensureVariableFor: aNode in: aScope ].
	(aNode isKindOf: JSNamedPropertyExpressionNode)
		ifTrue: [ ^ self ensurePropertyNamed: aNode name source ].
	((aNode isKindOf: JSFunctionNode) or: [ aNode isKindOf: JSArrowFunctionNode ])
		ifTrue: [ ^ aNode attributeNamed: #modelObject ifAbsent: [ nil ] ].
	^ nil
]

{ #category : #private }
FKDojoImporter >> moduleNameFrom: aLiteral [
	| name |
	name := aLiteral asPharoString.
	(name includes: $!)
		ifTrue: [ name := name copyFrom: 1 to: (name indexOf: $!) - 1 ].
	^ name
]

{ #category : #private }
FKDojoImporter >> moduleStringFor: aString in: aNode [
	aNode
		lookupNode: [ :each | 
			(each attributeNamed: #parameterMapping ifAbsent: [  ])
				ifNotNil: [ :dict | 
					(dict includesKey: aString)
						ifTrue: [ ^ dict at: aString ] ].
			false ].
	^ nil
]

{ #category : #private }
FKDojoImporter >> processAssignmentExpressions [
	assignmentExpressions do: [ :each | self processAssignmentFrom: each key rhs to: each key lhs in: each value ]
]

{ #category : #private }
FKDojoImporter >> processAssignmentFrom: rhsNode to: lhsNode in: aScope [
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
FKDojoImporter >> processCallExpressions [
	callExpressions
		do: [ :each | 
			| invocation receiver |
			invocation := FKJSInvocation new
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
FKDojoImporter >> processForIterator: aForStatement [
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
FKDojoImporter >> processVariableReference: node in: entity [
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
FKDojoImporter >> processVariableReferences [
	variableReferences
		do: [ :each | 
			| node entity |
			node := each key.
			entity := each value.
			self processVariableReference: node in: entity ]
]

{ #category : #'private-model' }
FKDojoImporter >> propertyNameForFunction: aFunction [
	(aFunction parent isKindOf: JSPropertyAssignmentNode)
		ifTrue: [ ^ aFunction parent name source ].
	((aFunction parent isKindOf: JSAssignmentExpressionNode) and: [ aFunction parent rhs == aFunction ])
		ifTrue: [ (aFunction parent lhs isKindOf: JSNamedPropertyExpressionNode)
				ifTrue: [ ^ aFunction parent lhs name source ] ].
	^ nil
]

{ #category : #accessing }
FKDojoImporter >> propertyNamed: aString [
	^ properties at: aString ifAbsent: [  ]
]

{ #category : #private }
FKDojoImporter >> relativeNameFor: anAstNode includeExtension: aBoolean [
	| fileReference |
	fileReference := anAstNode topParent filename asFileReference.
	aBoolean
		ifFalse: [ fileReference := fileReference withoutExtension ].
	^ (fileReference relativeTo: directory) printWithDelimiter: $/
]

{ #category : #accessing }
FKDojoImporter >> scriptNamed: aString [
	^ files detect: [ :each | each name = aString ] ifNone: [  ]
]

{ #category : #'private-model' }
FKDojoImporter >> sourceAnchorFor: aNode [
	^ FAMIXIndexedFileAnchor
		fileName: aNode topParent filename pathString
		startPos: aNode startPosition
		endPos: aNode stopPosition
		model: model
]

{ #category : #private }
FKDojoImporter >> startingImportingFile [
	variableReferences := OrderedCollection new.
	callExpressions := OrderedCollection new.
	assignmentExpressions := OrderedCollection new
]

{ #category : #private }
FKDojoImporter >> templateStringForNode: aNode [
	| name |
	(aNode isKindOf: JSNameExpressionNode)
		ifFalse: [ ^ nil ].
	name := self moduleStringFor: aNode name source in: aNode.
	(name includes: $!)
		ifTrue: [ name := name copyFrom: (name indexOf: $!) + 1 to: name size ].
	^ name
]

{ #category : #'private-model' }
FKDojoImporter >> variableNameForFunction: aFunction [
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
FKDojoImporter >> visitArrowFunction: anArrowFunction [
	^ self
		ensureFunctionNamed: (self functionNameFor: anArrowFunction)
		for: anArrowFunction
		around: [ super visitArrowFunction: anArrowFunction ]
]

{ #category : #visiting }
FKDojoImporter >> visitAssignmentExpression: anAssignmentExpression [
	anAssignmentExpression operator source = '='
		ifTrue: [ assignmentExpressions add: anAssignmentExpression -> self currentScope ].
	super visitAssignmentExpression: anAssignmentExpression
]

{ #category : #visiting }
FKDojoImporter >> visitCallExpression: aCallExpression [
	callExpressions add: aCallExpression -> self currentScope.
	super visitCallExpression: aCallExpression
]

{ #category : #visiting }
FKDojoImporter >> visitForInStatement: aForInStatement [
	self processForIterator: aForInStatement.
	super visitForInStatement: aForInStatement
]

{ #category : #visiting }
FKDojoImporter >> visitForOfStatement: aForOfStatement [
	self processForIterator: aForOfStatement.
	super visitForOfStatement: aForOfStatement
]

{ #category : #visiting }
FKDojoImporter >> visitForStatement: aForStatement [
	self addVariablesInToLocalScope: aForStatement.
	super visitForStatement: aForStatement
]

{ #category : #visiting }
FKDojoImporter >> visitFunction: aFunction [
	| mooseFunction var |
	var := nil.
	aFunction name notNil
		ifTrue: [ var := self ensureLocalVariableNamed: aFunction name source.
			(self processVariableReference: aFunction in: self currentScope) isWrite: true ].
	mooseFunction := self
		ensureFunctionNamed: (self functionNameFor: aFunction)
		for: aFunction
		around: [ super visitFunction: aFunction ].
	var notNil
		ifTrue: [ var addPotentialJSFunction: mooseFunction ].
	^ mooseFunction
]

{ #category : #visiting }
FKDojoImporter >> visitLexicalDeclaration: aNode [
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
FKDojoImporter >> visitModule: aModule [
	self createScriptFrom: aModule.
	self createCommentsFrom: aModule.
	super visitModule: aModule
]

{ #category : #visiting }
FKDojoImporter >> visitNameExpression: aNameExpression [
	aNameExpression isVariableReference
		ifTrue: [ variableReferences add: aNameExpression -> self currentScope ].
	super visitNameExpression: aNameExpression
]

{ #category : #visiting }
FKDojoImporter >> visitNamedPropertyExpression: aNamedPropertyExpression [
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
FKDojoImporter >> visitObjectLiteral: anObjectLiteral [
	anObjectLiteral definitions do: [ :each | self createPropertyFromDefinition: each ].
	super visitObjectLiteral: anObjectLiteral
]

{ #category : #visiting }
FKDojoImporter >> visitPropertyAssignment: aNode [
	aNode value isFunction
		ifTrue: [ ^ (self ensurePropertyNamed: aNode name source) addPotentialJSFunction: (aNode value acceptVisitor: self) ].
	super visitPropertyAssignment: aNode
]

{ #category : #visiting }
FKDojoImporter >> visitTryStatement: aTryStatement [
	| var name |
	aTryStatement exceptionType notNil
		ifTrue: [ name := aTryStatement exceptionType source.
			var := self ensureLocalVariableNamed: name.
			var sourceAnchor: (self sourceAnchorFor: aTryStatement exceptionType).
			(self processVariableReference: aTryStatement exceptionType in: self currentScope) isWrite: true ].
	super visitTryStatement: aTryStatement
]

{ #category : #visiting }
FKDojoImporter >> visitVariableStatement: aNode [
	self addVariablesInToLocalScope: aNode.
	super visitVariableStatement: aNode
]
