Class {
	#name : #GtJavaSpringEntity,
	#superclass : #FAMIXNamedEntity,
	#instVars : [
		'annotationInstance',
		'requests'
	],
	#category : #'GToolkit4Famix3-Java'
}

{ #category : #accessing }
GtJavaSpringEntity >> annotationInstance [
	<MSEProperty: #annotationInstance
		type: #FAMIXAnnotationInstance
		opposite: #gtJavaSpringEntity>
	^ annotationInstance
]

{ #category : #accessing }
GtJavaSpringEntity >> annotationInstance: anInstance [
	annotationInstance == anInstance ifTrue: [ ^ self ].
	annotationInstance ifNotNil: [ annotationInstance gtJavaSpringEntity: nil ].
	annotationInstance := anInstance.
	annotationInstance ifNotNil: [ annotationInstance gtJavaSpringEntity: self ]
]

{ #category : #accessing }
GtJavaSpringEntity >> buildRequests [
	self
		requests: (annotationInstance
				ifNil: [ #() ]
				ifNotNil: [ GtJavaSpringMapping
						requestsFor: annotationInstance annotatedEntity
						inModel: self mooseModel ])
]

{ #category : #accessing }
GtJavaSpringEntity >> owner [
	^ nil
]

{ #category : #accessing }
GtJavaSpringEntity >> requests [
	<MSEProperty: #requests type: #GtJavaSpringMapping opposite: #gtJavaSpringEntity>
	<multivalued>
	^ requests
		ifNil: [ requests := FMMultivalueLink on: self opposite: #gtJavaSpringEntity: ]
]

{ #category : #accessing }
GtJavaSpringEntity >> requests: aCollection [
	self requests value: aCollection
]
