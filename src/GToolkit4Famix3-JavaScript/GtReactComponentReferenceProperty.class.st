Class {
	#name : #GtReactComponentReferenceProperty,
	#superclass : #FAMIXSourcedEntity,
	#instVars : [
		'name',
		'reference',
		'parameters'
	],
	#category : #'GToolkit4Famix3-JavaScript-React'
}

{ #category : #initialization }
GtReactComponentReferenceProperty >> initialize [
	super initialize.
	parameters := FMMultiMultivalueLink
		on: self
		opposite: #reactProperties
]

{ #category : #accessing }
GtReactComponentReferenceProperty >> name [
	<MSEProperty: #name type: #String>
	^ name
]

{ #category : #accessing }
GtReactComponentReferenceProperty >> name: aString [
	name := aString.
	self resetMooseName
]

{ #category : #accessing }
GtReactComponentReferenceProperty >> parameters [
	<MSEProperty: #parameters type: #GtJSObjectBindingParameter opposite: #reactProperties>
	<multivalued>
	^ parameters
]

{ #category : #accessing }
GtReactComponentReferenceProperty >> parameters: aCollection [
	parameters nocheckValue: aCollection
]

{ #category : #accessing }
GtReactComponentReferenceProperty >> reference [
	<MSEProperty: #reference type: #GtReactComponentReference opposite: #reactComponentProperties>
	^ reference
]

{ #category : #accessing }
GtReactComponentReferenceProperty >> reference: aReference [
	reference := aReference
]
