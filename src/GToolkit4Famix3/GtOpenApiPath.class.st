Class {
	#name : #GtOpenApiPath,
	#superclass : #FAMIXSourcedEntity,
	#instVars : [
		'basePaths',
		'implementers',
		'pathItem'
	],
	#category : #'GToolkit4Famix3-OpenApi'
}

{ #category : #accessing }
GtOpenApiPath >> basePaths [
	^ basePaths ifNil: [ #('') ]
]

{ #category : #accessing }
GtOpenApiPath >> basePaths: anObject [
	basePaths := anObject
]

{ #category : #accessing }
GtOpenApiPath >> combine: aString with: bString [
	aString isEmpty ifTrue: [ ^ bString ].
	bString isEmpty ifTrue: [ ^ aString ].
	^ ((aString last = $/ and: [ bString first = $/ ])
		ifTrue: [ aString allButLast ]
		ifFalse: [ aString ]) , bString
]

{ #category : #accessing }
GtOpenApiPath >> endPoint [
	^ pathItem endPoint
]

{ #category : #accessing }
GtOpenApiPath >> fullPaths [
	^ basePaths collect: [ :each | self combine: each with: self endPoint ]
]

{ #category : #accessing }
GtOpenApiPath >> gtDisplayOn: aStream [
	aStream << self method << ' ' << self endPoint
]

{ #category : #accessing }
GtOpenApiPath >> implementers [
	<MSEProperty: #implementers type: #FAMIXEntity opposite: #gtOpenApiPaths>
	<multivalued>
	^ implementers
		ifNil: [ implementers := FMMultiMultivalueLink on: self opposite: #gtOpenApiPaths ]
]

{ #category : #accessing }
GtOpenApiPath >> implementers: aCollection [
	self implementers value: aCollection
]

{ #category : #accessing }
GtOpenApiPath >> method [
	^ #(delete get patch post put)
		detect: [ :method | (pathItem perform: method) notNil ]
		ifNone: [  ]
]

{ #category : #accessing }
GtOpenApiPath >> pathItem [
	^ pathItem
]

{ #category : #accessing }
GtOpenApiPath >> pathItem: anObject [
	pathItem := anObject
]
