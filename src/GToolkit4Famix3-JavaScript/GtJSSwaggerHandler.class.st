Class {
	#name : #GtJSSwaggerHandler,
	#superclass : #GtJSSwaggerEntity,
	#instVars : [
		'incomingCalls',
		'type',
		'urls'
	],
	#category : #'GToolkit4Famix3-JavaScript'
}

{ #category : #accessing }
GtJSSwaggerHandler >> fullPathsDo: aBlock [
	self urls do: [ :each | aBlock cull: each cull: type ]
]

{ #category : #'gt - extensions' }
GtJSSwaggerHandler >> gtIncomingCallsFor: aView [
	<gtView>
	^ aView forward
		title: 'Incoming calls';
		object: [ self incomingCalls asMooseGroup ];
		view: #gtItemsFor:
]

{ #category : #accessing }
GtJSSwaggerHandler >> incomingCalls [
	<MSEProperty: #incomingCalls type: #GtJSSwaggerCall opposite: #candidates>
	<multivalued>
	^ incomingCalls
		ifNil: [ incomingCalls := FMMultiMultivalueLink on: self opposite: #candidates ]
]

{ #category : #accessing }
GtJSSwaggerHandler >> incomingCalls: aCollection [
	self incomingCalls value: aCollection
]

{ #category : #accessing }
GtJSSwaggerHandler >> mooseNameOn: aStream [
	aStream << type << ' ' << self url
]

{ #category : #accessing }
GtJSSwaggerHandler >> parentPackage [
	^ self annotationInstance annotatedEntity parentPackage
]

{ #category : #accessing }
GtJSSwaggerHandler >> type [
	^ type
]

{ #category : #accessing }
GtJSSwaggerHandler >> type: aString [
	type := aString
]

{ #category : #accessing }
GtJSSwaggerHandler >> url [
	^ self urls isEmpty ifTrue: [ '' ] ifFalse: [ self urls first ]
]

{ #category : #accessing }
GtJSSwaggerHandler >> urls [
	^ urls
]

{ #category : #accessing }
GtJSSwaggerHandler >> urls: aString [
	urls := aString
]
