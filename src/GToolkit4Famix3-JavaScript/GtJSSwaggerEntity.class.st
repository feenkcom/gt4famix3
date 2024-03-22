Class {
	#name : #GtJSSwaggerEntity,
	#superclass : #FAMIXEntity,
	#instVars : [
		'annotationInstance'
	],
	#category : #'GToolkit4Famix3-JavaScript'
}

{ #category : #accessing }
GtJSSwaggerEntity >> annotationInstance [
	<MSEProperty: #annotationInstance
		type: #FAMIXAnnotationInstance
		opposite: #gtJSwaggerEntity>
	^ annotationInstance
]

{ #category : #accessing }
GtJSSwaggerEntity >> annotationInstance: anInstance [
	annotationInstance == anInstance ifTrue: [ ^ self ].
	annotationInstance ifNotNil: [ annotationInstance gtJSwaggerEntity: nil ].
	annotationInstance := anInstance.
	annotationInstance ifNotNil: [ annotationInstance gtJSwaggerEntity: self ]
]

{ #category : #accessing }
GtJSSwaggerEntity >> gtSourceFor: aView [
	<gtView>
	(annotationInstance isNil or: [ annotationInstance sourceAnchor isNil ])
		ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Complete source';
		object: [ annotationInstance ];
		view: #gtSourceFor:
]
