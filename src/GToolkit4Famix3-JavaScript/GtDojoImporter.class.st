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
	#name : #GtDojoImporter,
	#superclass : #GtJSImporter,
	#instVars : [
		'currentModule',
		'patterns'
	],
	#category : #'GToolkit4Famix3-JavaScript-Dojo'
}

{ #category : #visiting }
GtDojoImporter >> acceptNode: aSmaCCParseNode [
	patterns
		do: [ :each | 
			(each execute: aSmaCCParseNode)
				ifTrue: [ ^ self ] ].
	^ super acceptNode: aSmaCCParseNode
]

{ #category : #private }
GtDojoImporter >> addDojoClassPatternFor: aVariableDeclarationNode [
	<gtIgnoreConstraint: #GtRBAcceptVisitorCalledFromNonVisitingMethods>
	| patternAsts patternStrings declareName |
	patternStrings := #('<1s>([``?supers{beList}`], { ``?props{beList}` })' '<1s>(``?super`, { ``?props{beList}` })' '<1s>(``?name`, [``?supers{beList}`], { ``?props{beList}` })' '<1s>(`?name`, ``?super`, { ``?props{beList}` })').
	declareName := aVariableDeclarationNode variable source.
	patternAsts := patternStrings
		inject: OrderedCollection new
		into: [ :sum :each | 
			sum
				addAll: (JSParser parseAndCacheAll: (each expandMacrosWith: declareName) startingAt: JSParser startingStateForExpression);
				yourself ].
	patterns
		add:
			(GtAstPatternRunner
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
GtDojoImporter >> createDojoClass: objectNode withSupers: aCollection named: aString [
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
GtDojoImporter >> createDojoModule: aNode around: aBlock [
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
GtDojoImporter >> ensureDojoClassForNode: aNode [
	| name |
	(aNode isKindOf: JSNameExpressionNode)
		ifFalse: [ ^ nil ].
	name := self moduleStringFor: aNode name source in: aNode.
	^ self ensureDojoClassNamed: name
]

{ #category : #'private-model' }
GtDojoImporter >> ensureDojoClassNamed: aString [
	| name |
	name := aString copyReplaceAll: '/' with: '.'.
	^ classes at: name ifAbsentPut: [ model add: (GtDojoClass new name: name) ]
]

{ #category : #'private-model' }
GtDojoImporter >> ensureDojoModuleNamed: aString [
	^ modules at: aString ifAbsentPut: [ model add: (GtDojoModule new name: aString) ]
]

{ #category : #private }
GtDojoImporter >> fileNameFrom: aLiteral [
	| name |
	name := aLiteral asPharoString.
	(name includes: $!)
		ifTrue: [ name := name copyFrom: (name indexOf: $!) + 1 to: name size ].
	^ name
]

{ #category : #'initialize-release' }
GtDojoImporter >> initialize [
	super initialize.
	patterns := OrderedCollection new.
	self initializeModulePatterns.
	self initializeClassPatterns
]

{ #category : #private }
GtDojoImporter >> initializeClassPatterns [
	
]

{ #category : #private }
GtDojoImporter >> initializeModulePatterns [
	<gtIgnoreConstraint: #GtRBAcceptVisitorCalledFromNonVisitingMethods>
	| patternAsts runner |
	patternAsts := JSParser
		parseAndCacheAll: 'define([``?prereqs{beList}`], function (``?args{beList}`) { ``?statements{beList}` })'
		startingAt: JSParser startingStateForExpression.
	runner := GtAstPatternRunner forPatterns: patternAsts do: [ :node | self createDojoModule: node around: [ node acceptVisitor: self ] ].
	patterns add: runner
]

{ #category : #private }
GtDojoImporter >> moduleNameFrom: aLiteral [
	| name |
	name := aLiteral asPharoString.
	(name includes: $!)
		ifTrue: [ name := name copyFrom: 1 to: (name indexOf: $!) - 1 ].
	^ name
]

{ #category : #private }
GtDojoImporter >> moduleStringFor: aString in: aNode [
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
GtDojoImporter >> templateStringForNode: aNode [
	| name |
	(aNode isKindOf: JSNameExpressionNode)
		ifFalse: [ ^ nil ].
	name := self moduleStringFor: aNode name source in: aNode.
	(name includes: $!)
		ifTrue: [ name := name copyFrom: (name indexOf: $!) + 1 to: name size ].
	^ name
]
