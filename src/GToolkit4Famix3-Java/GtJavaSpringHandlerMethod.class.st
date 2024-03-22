Class {
	#name : #GtJavaSpringHandlerMethod,
	#superclass : #GtJavaSpringEntity,
	#instVars : [
		'controller'
	],
	#category : #'GToolkit4Famix3-Java'
}

{ #category : #accessing }
GtJavaSpringHandlerMethod >> controller [
	<MSEProperty: #controller type: #GtJavaSpringRestController opposite: #handlers>
	^ controller
]

{ #category : #accessing }
GtJavaSpringHandlerMethod >> controller: aController [
	controller := FMMultivalueLink
			on: self
			update: #handlers
			from: self controller
			to: aController
]

{ #category : #accessing }
GtJavaSpringHandlerMethod >> gtJavaSpringMapping [
	<navigation: 'Spring Mapping'>
	^ self annotationInstance gtJavaSpringMapping
]

{ #category : #accessing }
GtJavaSpringHandlerMethod >> javaMethod [ 
	^ self annotationInstance annotatedEntity
]

{ #category : #accessing }
GtJavaSpringHandlerMethod >> mooseNameOn: aStream [
	self javaMethod mooseNameOn: aStream
]

{ #category : #accessing }
GtJavaSpringHandlerMethod >> owner [
	^ self controller
]
