Class {
	#name : #GtJavaSpringCall,
	#superclass : #FAMIXAssociation,
	#instVars : [
		'candidates',
		'caller',
		'requestType',
		'url',
		'contentType',
		'accepts'
	],
	#category : #'GToolkit4Famix3-Java'
}

{ #category : #accessing }
GtJavaSpringCall >> accepts [
	^ accepts
]

{ #category : #accessing }
GtJavaSpringCall >> accepts: anObject [
	accepts := anObject
]

{ #category : #accessing }
GtJavaSpringCall >> caller [
	<MSEProperty: #caller
		type: #FAMIXNamedEntity
		opposite: #outgoingGtJavaSpringCalls>
	<source>
	^ caller
]

{ #category : #accessing }
GtJavaSpringCall >> caller: anObject [
	caller ifNotNil: [ caller outgoingGtJavaSpringCalls remove: self ifAbsent: [  ] ].
	caller := anObject.
	caller ifNotNil: [ caller outgoingGtJavaSpringCalls add: self ]
]

{ #category : #accessing }
GtJavaSpringCall >> candidates [
	<MSEProperty: #candidates type: #GtJavaSpringMapping opposite: #incomingCalls>
	<multivalued>
	^ candidates
		ifNil: [ candidates := FMMultiMultivalueLink on: self opposite: #incomingCalls ]
]

{ #category : #accessing }
GtJavaSpringCall >> candidates: aCollection [
	self candidates nocheckValue: aCollection
]

{ #category : #accessing }
GtJavaSpringCall >> contentType [
	^ contentType
]

{ #category : #accessing }
GtJavaSpringCall >> contentType: anObject [
	contentType := anObject
]

{ #category : #accessing }
GtJavaSpringCall >> from [
	^ self caller
]

{ #category : #accessing }
GtJavaSpringCall >> from: anObject [
	self caller: anObject
]

{ #category : #accessing }
GtJavaSpringCall >> fromProject [
	<navigation: 'From project'>
	^ self from ifNotNil: #parentPackage
]

{ #category : #accessing }
GtJavaSpringCall >> gtCandidatesFor: aView [
	<gtView>
	^ aView forward 
		title: 'Candidates';
		object: [ candidates asMooseGroup ];
		view: #gtItemsFor:
]

{ #category : #accessing }
GtJavaSpringCall >> isFromJUnit4Test [
	^ (self from isKindOf: FAMIXFunction)
		ifTrue: [ self from typeScope isJUnit4TestCase ]
		ifFalse: [ (self from isKindOf: FAMIXMethod)
				ifTrue: [ self from typeScope isJUnit4TestCase ]
				ifFalse: [ false ] ]
]

{ #category : #accessing }
GtJavaSpringCall >> isFromTestPath [
	^ (self sourceAnchor fileName includesSubstring: 'src\test')
		or: [ self sourceAnchor fileName includesSubstring: 'src/test' ]
]

{ #category : #testing }
GtJavaSpringCall >> isInsideOfSameProject [
	^ self toProjects size = 1 and: [ self toProjects includes: self fromProject ]
]

{ #category : #accessing }
GtJavaSpringCall >> parentPackage [
	^ self from parentPackage
]

{ #category : #accessing }
GtJavaSpringCall >> requestType [
	^ requestType
]

{ #category : #accessing }
GtJavaSpringCall >> requestType: aString [
	requestType := aString
]

{ #category : #accessing }
GtJavaSpringCall >> to [
	^ self candidates
]

{ #category : #accessing }
GtJavaSpringCall >> to: aCollection [
	^ self candidates: aCollection
]

{ #category : #accessing }
GtJavaSpringCall >> toProjects [
	<navigation: 'To projects'>
	^ self to collectAsSet: #parentPackage
]

{ #category : #accessing }
GtJavaSpringCall >> url [
	^ url
]

{ #category : #accessing }
GtJavaSpringCall >> url: aString [
	url := aString
]
