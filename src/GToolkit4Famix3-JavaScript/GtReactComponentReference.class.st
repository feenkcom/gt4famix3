Class {
	#name : #GtReactComponentReference,
	#superclass : #FAMIXAssociation,
	#instVars : [
		'name',
		'sender',
		'candidates',
		'reactComponentAttributes'
	],
	#category : #'GToolkit4Famix3-JavaScript-React'
}

{ #category : #accessing }
GtReactComponentReference >> candidates [
	<MSEProperty: #candidates type: #GtReactFunctionComponent opposite: #incomingReactComponentReferences>
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
		opposite: #incomingReactComponentReferences.
	reactComponentAttributes := FMMultivalueLink on: self opposite: #reference:
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
GtReactComponentReference >> reactComponentProperties [
	<MSEProperty: #reactComponentProperties type: #GtReactComponentReferenceProperty opposite: #reference>
	<multivalued>
	^ reactComponentAttributes
]

{ #category : #accessing }
GtReactComponentReference >> reactComponentProperties: aCollection [
	reactComponentAttributes nocheckValue: aCollection
]

{ #category : #accessing }
GtReactComponentReference >> sender [
	<MSEProperty: #sender type: #FAMIXBehaviouralEntity opposite: #outgoingReactComponentReferences>
	^sender
]

{ #category : #accessing }
GtReactComponentReference >> sender: aBehaviouralEntity [
	sender := FMMultivalueLink
		on: self
		update: #outgoingReactComponentReferences
		from: self sender
		to: aBehaviouralEntity
]

{ #category : #accessing }
GtReactComponentReference >> to [
	^ self candidates notEmpty
		ifTrue: [ self candidates first ]
]
