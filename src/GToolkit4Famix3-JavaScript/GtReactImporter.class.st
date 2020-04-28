Class {
	#name : #GtReactImporter,
	#superclass : #GtJSImporter,
	#instVars : [
		'functionComponents'
	],
	#category : #'GToolkit4Famix3-JavaScript-React'
}

{ #category : #importing }
GtReactImporter >> finishImport [
	| components |
	super finishImport.
	components := Dictionary new.
	model allReactComponents
		do: [ :each | 
			(components at: each name ifAbsentPut: [ OrderedCollection new ])
				add: each ].
	model allReactComponentReferences
		do:
			[ :each | each candidates addAll: (components at: each name ifAbsent: [ #() ]) ]
]

{ #category : #'private-model' }
GtReactImporter >> functionClassFor: aFunctionNode [
	^ (self isCodeItem: self currentScope)
		ifTrue: [ (self isReactComponent: aFunctionNode)
				ifTrue: [ GtReactFunctionComponent ]
				ifFalse: [ FAMIXFunction ] ]
		ifFalse: [ FAMIXMethod ]
]

{ #category : #initialization }
GtReactImporter >> initialize [
	super initialize.
	self parserClass: JSXParser.
	functionComponents := Dictionary new
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

{ #category : #generated }
GtReactImporter >> visitXElement: aNode [
	| reference |
	reference := GtReactComponentReference new.
	reference name: aNode openingElement name source.
	reference sender: self codeScope.
	model add: reference.
	reference sourceAnchor: (self sourceAnchorFor: aNode).
	super visitXElement: aNode
]

{ #category : #generated }
GtReactImporter >> visitXSelfClosingElement: aNode [
	| reference |
	reference := GtReactComponentReference new.
	reference name: aNode name source.
	reference sender: self codeScope.
	model add: reference.
	reference sourceAnchor: (self sourceAnchorFor: aNode).
	super visitXElement: aNode
]
