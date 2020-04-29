Class {
	#name : #GtReactComponentReferenceAttribute,
	#superclass : #FAMIXSourcedEntity,
	#instVars : [
		'name',
		'reference'
	],
	#category : #'GToolkit4Famix3-JavaScript-React'
}

{ #category : #accessing }
GtReactComponentReferenceAttribute >> name [
	<MSEProperty: #name type: #String>
	^ name
]

{ #category : #accessing }
GtReactComponentReferenceAttribute >> name: aString [
	name := aString.
	self resetMooseName
]

{ #category : #accessing }
GtReactComponentReferenceAttribute >> reference [
	<MSEProperty: #reference type: #GtReactComponentReference opposite: #reactComponentAttributes>
	^ reference
]

{ #category : #accessing }
GtReactComponentReferenceAttribute >> reference: aReference [
	reference := aReference
]
