Class {
	#name : #GtReactImporter,
	#superclass : #GtJSImporter,
	#instVars : [
		'functionComponents',
		'elementStack'
	],
	#category : #'GToolkit4Famix3-JavaScript-React'
}

{ #category : #importing }
GtReactImporter >> filterPotentialCandidates: aCollection for: aComponentReference [
	| imports fileMap |
	aCollection size < 2 ifTrue: [ ^ aCollection ].
	imports := #().
	aComponentReference gtASTNode
		ifNotNil:
			[ :node | 
			(node parentOfType: JSModuleNode)
				ifNotNil: [ :module | imports := module items select: [ :each | each isKindOf: JSImportDeclarationNode ] ] ].
	fileMap := aCollection
		inject: Dictionary new
		into:
			[ :sum :each | 
			sum
				at: (each gtASTNode topParent ifNotNil: [ :node | node filename asFileReference resolve withoutExtension ]) put: each;
				yourself ].
	imports
		do:
			[ :each | 
			each
				allNodesOfType: JSNameExpressionNode
				do:
					[ :nameNode | 
					nameNode name source = aComponentReference name
						ifTrue:
							[ fileMap
								at:
									(self
										lookupFile: (each from source copyFrom: 2 to: each from source size - 1)
										from: aComponentReference gtASTNode topParent filename asFileReference parent) withoutExtension
								ifPresent: [ :component | ^ {component} ] ] ] ].
	(imports
		collect:
			[ :each | 
			fileMap
				at:
					(self
						lookupFile: (each from source copyFrom: 2 to: each from source size - 1)
						from: aComponentReference gtASTNode topParent filename asFileReference parent) withoutExtension
				ifAbsent: [  ] ]
		thenSelect: #notNil) ifNotEmpty: [ :collection | ^ collection ].
	^ aCollection
]

{ #category : #importing }
GtReactImporter >> finishImport [
	super finishImport.
	self hookupComponentReferences
]

{ #category : #'private-model' }
GtReactImporter >> functionClassFor: aFunctionNode [
	^ (self isCodeItem: self currentScope)
		ifTrue: [ (self isReactComponent: aFunctionNode)
				ifTrue: [ GtReactFunctionComponent ]
				ifFalse: [ FAMIXFunction ] ]
		ifFalse: [ FAMIXMethod ]
]

{ #category : #importing }
GtReactImporter >> hookupComponentParametersFor: componentReference [
	componentReference reactComponentProperties
		do: [ :prop | 
			componentReference candidates
				do: [ :each | 
					| parm |
					parm := each parameters
						detect: [ :p | p name = prop name ]
						ifNone: [ nil ].
					parm notNil
						ifTrue: [ prop parameters add: parm ] ] ]
]

{ #category : #importing }
GtReactImporter >> hookupComponentReferences [
	| components |
	components := Dictionary new.
	model allReactComponents do: [ :each | (components at: each name ifAbsentPut: [ OrderedCollection new ]) add: each ].
	model allReactComponentReferences
		do:
			[ :each | 
			each candidates addAll: (self filterPotentialCandidates: (components at: each name ifAbsent: [ #() ]) for: each).
			self hookupComponentParametersFor: each ]
]

{ #category : #initialization }
GtReactImporter >> initialize [
	super initialize.
	self parserClass: JSXParser.
	functionComponents := Dictionary new.
	elementStack := OrderedCollection new
]

{ #category : #testing }
GtReactImporter >> isReactComponent: aFunctionNode [
	"Guess that it is a component if it contains an <element> in a return statement"

	aFunctionNode
		allNodesOfType: JSReturnStatementNode
		do: [ :return | 
			return
				allNodesDo: [ :node | 
					((node isKindOf: JSXElementNode)
						or: [ node isKindOf: JSXSelfClosingElementNode ])
						ifTrue: [ ^ true ] ] ].
	^ false
]

{ #category : #importing }
GtReactImporter >> lookupFile: aString from: aDirectory [
	(aString beginsWith: '../') ifTrue: [ ^ self lookupFile: (aString allButFirst: 3) from: aDirectory parent ].
	^ aDirectory / aString
]

{ #category : #visiting }
GtReactImporter >> visitXAttribute: aNode [
	| attribute |
	(aNode value notNil and: [ elementStack notEmpty ])
		ifTrue: [ attribute := GtReactComponentReferenceProperty new.
			attribute name: aNode name source.
			attribute sourceAnchor: (self sourceAnchorFor: aNode).
			self storeAST: aNode into: attribute.
			elementStack last reactComponentProperties add: attribute.
			model add: attribute.
			currentFile addEntity: attribute ].
	^ super visitXAttribute: aNode
]

{ #category : #visiting }
GtReactImporter >> visitXElement: aNode [
	| reference |
	reference := GtReactComponentReference new.
	reference name: aNode openingElement name source.
	reference sender: self codeScope.
	model add: reference.
	reference sourceAnchor: (self sourceAnchorFor: aNode).
	self storeAST: aNode into: reference.
	elementStack add: reference.
	[ super visitXElement: aNode ]
		ensure: [ elementStack removeLast ]
]

{ #category : #visiting }
GtReactImporter >> visitXSelfClosingElement: aNode [
	| reference |
	reference := GtReactComponentReference new.
	reference name: aNode name source.
	reference sender: self codeScope.
	model add: reference.
	reference sourceAnchor: (self sourceAnchorFor: aNode).
	self storeAST: aNode into: reference.
	elementStack add: reference.
	[ super visitXElement: aNode ]
		ensure: [ elementStack removeLast ]
]
