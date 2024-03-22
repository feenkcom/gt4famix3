Class {
	#name : #GtJavaSpringRestController,
	#superclass : #GtJavaSpringEntity,
	#instVars : [
		'handlers'
	],
	#category : #'GToolkit4Famix3-Java'
}

{ #category : #accessing }
GtJavaSpringRestController >> gtHandlersFor: aView [
	<gtView>
	^ aView list 
		title: 'Handlers';
		items: [ self handlers ]
]

{ #category : #accessing }
GtJavaSpringRestController >> handlers [
	<MSEProperty: #handlers type: #GtJavaSpringHandlerMethod opposite: #controller>
	<multivalued>
	^ handlers
		ifNil: [ handlers := FMMultivalueLink on: self opposite: #controller: ]
]

{ #category : #accessing }
GtJavaSpringRestController >> handlers: aCollection [
	self handlers value: aCollection
]
