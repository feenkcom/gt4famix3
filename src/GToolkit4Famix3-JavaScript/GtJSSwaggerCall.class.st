Class {
	#name : #GtJSSwaggerCall,
	#superclass : #FAMIXAssociation,
	#instVars : [
		'candidates',
		'caller',
		'requestType',
		'url'
	],
	#category : #'GToolkit4Famix3-JavaScript'
}

{ #category : #accessing }
GtJSSwaggerCall >> caller [
	<MSEProperty: #caller
		type: #FAMIXNamedEntity
		opposite: #outgoingGtJSSwaggerCalls>
	<source>
	^ caller
]

{ #category : #accessing }
GtJSSwaggerCall >> caller: anObject [
	caller ifNotNil: [ caller outgoingGtJSSwaggerCalls remove: self ifAbsent: [  ] ].
	caller := anObject.
	caller ifNotNil: [ caller outgoingGtJSSwaggerCalls add: self ]
]

{ #category : #accessing }
GtJSSwaggerCall >> candidates [
	<MSEProperty: #candidates type: #GtJSSwaggerHandler opposite: #incomingCalls>
	<multivalued>
	^ candidates
		ifNil: [ candidates := FMMultiMultivalueLink on: self opposite: #incomingCalls ]
]

{ #category : #accessing }
GtJSSwaggerCall >> candidates: aCollection [
	self candidates nocheckValue: aCollection
]

{ #category : #accessing }
GtJSSwaggerCall >> from [
	^ self caller
]

{ #category : #accessing }
GtJSSwaggerCall >> from: anObject [
	self caller: anObject
]

{ #category : #accessing }
GtJSSwaggerCall >> fromProject [
	<navigation: 'From project'>
	^ self from ifNotNil: #parentPackage
]

{ #category : #accessing }
GtJSSwaggerCall >> fullPathsDo: aBlock [
	aBlock cull: url cull: requestType
]

{ #category : #testing }
GtJSSwaggerCall >> isInsideOfSameProject [
	^ self toProjects size = 1 and: [ self toProjects includes: self fromProject ]
]

{ #category : #accessing }
GtJSSwaggerCall >> mooseNameOn: aStream [
	aStream << (requestType ifNil: [ '' ]) << ': ' << self url
]

{ #category : #accessing }
GtJSSwaggerCall >> requestType [
	^ requestType
]

{ #category : #accessing }
GtJSSwaggerCall >> requestType: anObject [
	requestType := anObject
]

{ #category : #accessing }
GtJSSwaggerCall >> resolvedUrl [
	^ (self to collect: #url) ifEmpty: [ self url ] ifNotEmpty: #first
]

{ #category : #accessing }
GtJSSwaggerCall >> technologyType [
	^ 'REST'
]

{ #category : #accessing }
GtJSSwaggerCall >> to [
	^ self candidates
]

{ #category : #accessing }
GtJSSwaggerCall >> to: aCollection [
	^ self candidates: aCollection
]

{ #category : #accessing }
GtJSSwaggerCall >> toProjects [
	<navigation: 'To projects'>
	^ self to collectAsSet: #parentPackage
]

{ #category : #accessing }
GtJSSwaggerCall >> url [
	^ url ifNil: [ '' ]
]

{ #category : #accessing }
GtJSSwaggerCall >> url: anObject [
	url := anObject
]
