Class {
	#name : #GtJavaSpringMapping,
	#superclass : #FAMIXEntity,
	#traits : 'TEntityMetaLevelDependency',
	#classTraits : 'TEntityMetaLevelDependency classTrait',
	#instVars : [
		'type',
		'springEntity',
		'annotationInstance',
		'paths',
		'produces',
		'consumes',
		'incomingCalls'
	],
	#category : #'GToolkit4Famix3-Java'
}

{ #category : #accessing }
GtJavaSpringMapping class >> parentSelectors [
	^ #()
]

{ #category : #accessing }
GtJavaSpringMapping class >> requestsFor: anEntity inModel: aModel [
	^ (anEntity annotationInstances
		select: [ :each | 
			'org::springframework::web::bind::annotation::*Mapping'
				match: each annotationType mooseName ])
		collect: [ :each | 
			self new
				mooseModel: aModel;
				buildFrom: each ]
]

{ #category : #accessing }
GtJavaSpringMapping >> annotationInstance [
	<MSEProperty: #annotationInstance
		type: #FAMIXAnnotationInstance
		opposite: #gtJavaSpringMapping>
	^ annotationInstance
]

{ #category : #accessing }
GtJavaSpringMapping >> annotationInstance: anInstance [
	annotationInstance == anInstance ifTrue: [ ^ self ].
	annotationInstance ifNotNil: [ annotationInstance gtJavaSpringMapping: nil ].
	annotationInstance := anInstance.
	annotationInstance ifNotNil: [ annotationInstance gtJavaSpringMapping: self ]
]

{ #category : #accessing }
GtJavaSpringMapping >> buildFrom: annotationInst [
	| node annotationType name |
	self annotationInstance: annotationInst.
	node := annotationInst gtASTNode.
	annotationType := annotationInst annotationType.
	name := annotationType name.
	name ~= 'RequestMapping'
		ifTrue: [ type := (name asString allButLast: 7) asLowercase asSymbol ]
		ifFalse: [ node values
				do: [ :each | 
					((each isKindOf: JavaElementValuePairNode)
						and: [ each name source = 'method'
								and: [ each value isKindOf: JavaQualifiedNameNode ] ])
						ifTrue: [ type := each value name source asLowercase asSymbol ] ] ].
	node values
		do: [ :each | 
			(each isKindOf: JavaElementValuePairNode)
				ifTrue: [ (#('path' 'value') includes: each name source)
						ifTrue: [ paths := self valuesIn: each value ].
					each name source = 'produces'
						ifTrue: [ produces := self valuesIn: each value ].
					each name source = 'consumes'
						ifTrue: [ consumes := self valuesIn: each value ] ] ].
	paths
		ifNil: [ node values
				do: [ :each | 
					(paths isNil and: [ each isKindOf: JavaElementValuePairNode ])
						ifFalse: [ paths := self valuesIn: each ] ] ].
	paths ifNil: [ paths := #('') ]
]

{ #category : #accessing }
GtJavaSpringMapping >> consumes [
	^ consumes ifNil: [ #() ]
]

{ #category : #accessing }
GtJavaSpringMapping >> consumes: anObject [
	^ consumes := anObject
]

{ #category : #accessing }
GtJavaSpringMapping >> fullPaths [
	| fullPaths |
	fullPaths := OrderedCollection new.
	self fullPathsDo: [ :each | fullPaths add: each ].
	^ fullPaths
]

{ #category : #accessing }
GtJavaSpringMapping >> fullPathsDo: aBlock [
	self gtJavaSpringEntity owner
		ifNotNil: [ :owner | 
			owner requests
				ifNotEmpty: [ :reqs | 
					reqs
						do: [ :req | 
							req fullPaths
								ifNotEmpty: [ :outerPaths | ^ outerPaths do: [ :o | self paths do: [ :e | aBlock cull: o , e cull: type ] ] ] ] ] ].
	self paths do: [ :each | aBlock cull: each cull: type ]
]

{ #category : #accessing }
GtJavaSpringMapping >> gtIncomingCallsFor: aView [
	<gtView>
	^ aView forward
		title: 'Incoming calls';
		priority: 1;
		object: [ self incomingCalls asMooseGroup ];
		view: #gtItemsFor:
]

{ #category : #accessing }
GtJavaSpringMapping >> gtJavaSpringEntity [
	<MSEProperty: #gtJavaSpringEntity type: #GtJavaSpringEntity opposite: #requests>
	^ springEntity
]

{ #category : #accessing }
GtJavaSpringMapping >> gtJavaSpringEntity: anObject [
	springEntity := FMMultivalueLink
			on: self
			update: #requests
			from: self gtJavaSpringEntity
			to: anObject
]

{ #category : #accessing }
GtJavaSpringMapping >> gtPathsFor: aView [
	<gtView>
	^ aView list 
		title: 'Paths';
		items: [ self fullPaths ]
]

{ #category : #accessing }
GtJavaSpringMapping >> gtSourceFor: aView [
	<gtView>
	(annotationInstance isNil or: [ annotationInstance sourceAnchor isNil ])
		ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Complete source';
		object: [ annotationInstance ];
		view: #gtSourceFor:
]

{ #category : #accessing }
GtJavaSpringMapping >> hasRegularSpringCalls [
	^ (self incomingCalls reject: #isFromJUnit4Test) notEmpty
]

{ #category : #accessing }
GtJavaSpringMapping >> incomingCalls [
	<MSEProperty: #incomingCalls type: #GtJavaSpringCall opposite: #candidates>
	<multivalued>
	<derived>
	^ incomingCalls
		ifNil: [ incomingCalls := FMMultiMultivalueLink on: self opposite: #candidates ]
]

{ #category : #accessing }
GtJavaSpringMapping >> incomingCalls: aCollection [
	self incomingCalls value: aCollection
]

{ #category : #accessing }
GtJavaSpringMapping >> isSpringCalledFromJUnit [
	^ (self incomingCalls select: #isFromJUnit4Test) notEmpty
]

{ #category : #accessing }
GtJavaSpringMapping >> isSpringCalledFromJUnit4Test [
	^ self isSpringCalledFromJUnit
]

{ #category : #accessing }
GtJavaSpringMapping >> isSpringCalledFromRegularCode [
	^ self hasRegularSpringCalls
]

{ #category : #accessing }
GtJavaSpringMapping >> mooseNameOn: aStream [
	aStream << (type ifNil: [ '' ]) << ':'
		<< (self fullPaths ifEmpty: [ '' ] ifNotEmpty: [ :c | c first ]) << '->'.
	springEntity ifNotNil: [ springEntity mooseNameOn: aStream ]
]

{ #category : #accessing }
GtJavaSpringMapping >> parentPackage [
	^ springEntity parentPackage
]

{ #category : #accessing }
GtJavaSpringMapping >> paths [
	^ paths ifNil: [ #() ]
]

{ #category : #accessing }
GtJavaSpringMapping >> produces [
	^ produces ifNil: [ #() ]
]

{ #category : #accessing }
GtJavaSpringMapping >> produces: anObject [
	produces := anObject
]

{ #category : #accessing }
GtJavaSpringMapping >> type [
	^ type
]

{ #category : #accessing }
GtJavaSpringMapping >> type: anObject [
	type := anObject
]

{ #category : #private }
GtJavaSpringMapping >> valueOf: aNode [
	^ GtSmaCCJavaImporter valueOf: aNode in: self mooseModel
]

{ #category : #private }
GtJavaSpringMapping >> valuesIn: aNode [
	^ (aNode isKindOf: JavaElementArrayInitializerNode)
		ifTrue: [ aNode values collect: [ :each | self valueOf: each ] ]
		ifFalse: [ {self valueOf: aNode} ]
]
