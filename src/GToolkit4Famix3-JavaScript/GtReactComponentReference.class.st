Class {
	#name : #GtReactComponentReference,
	#superclass : #FAMIXAssociation,
	#instVars : [
		'name',
		'sender',
		'candidates'
	],
	#category : #'GToolkit4Famix3-JavaScript-React'
}

{ #category : #accessing }
GtReactComponentReference >> candidates [
	<MSEProperty: #candidates type: #GtReactFunctionComponent opposite: #incomingElements>
	<multivalued>
	^ candidates
]

{ #category : #accessing }
GtReactComponentReference >> candidates: aCollection [ 
	candidates nocheckValue: aCollection
]

{ #category : #accessing }
GtReactComponentReference >> from [
	^ self sender
]

{ #category : #initialization }
GtReactComponentReference >> initialize [
	super initialize.
	candidates := FMMultiMultivalueLink
		on: self
		opposite: #incomingElements
]

{ #category : #accessing }
GtReactComponentReference >> name [
	<MSEProperty: #name type: #String>
	^ name
]

{ #category : #accessing }
GtReactComponentReference >> name: aString [
	name := aString
]

{ #category : #accessing }
GtReactComponentReference >> sender [
	<MSEProperty: #sender type: #FAMIXBehaviouralEntity opposite: #reactElements>
	^sender
]

{ #category : #accessing }
GtReactComponentReference >> sender: aBehaviouralEntity [
	sender := FMMultivalueLink
		on: self
		update: #reactElements
		from: self sender
		to: aBehaviouralEntity
]

{ #category : #accessing }
GtReactComponentReference >> to [
	^ self candidates notEmpty
		ifTrue: [ self candidates first ]
]
