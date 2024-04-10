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

{ #category : #private }
GtJavaSpringMapping >> fullNameOf: aNode [
	^ (aNode isKindOf: JavaQualifiedNameNode)
		ifTrue: [ (self fullNameOf: aNode nspace) , '::' , aNode name source ]
		ifFalse: [ aNode name source ]
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

{ #category : #private }
GtJavaSpringMapping >> lookupTypeFor: aNode [
	(aNode isKindOf: JavaQualifiedNameNode)
		ifTrue: [ (self mooseModel entityNamed: (self fullNameOf: aNode)) ifNotNil: [ :t | ^ t ] ].
	aNode class = JavaNameNode
		ifTrue: [ aNode topParent imports
				do: [ :each | 
					(each staticToken isNil and: [ each name name source = aNode name source ])
						ifTrue: [ (self mooseModel entityNamed: (self fullNameOf: each name))
								ifNotNil: [ :t | ^ t ] ] ].
			aNode topParent packageDeclaration
				ifNotNil: [ :decl | 
					(self mooseModel
						entityNamed: (self fullNameOf: decl name) , '::' , aNode name source)
						ifNotNil: [ :e | ^ e ] ].
			aNode topParent imports
				do: [ :each | 
					(each staticToken isNil
						and: [ each isKindOf: JavaTypeImportOnDemandDeclarationNode ])
						ifTrue: [ (self mooseModel
								entityNamed: (self fullNameOf: each name) , '::' , aNode name source)
								ifNotNil: [ :e | ^ e ] ] ] ].
	^ nil
]

{ #category : #private }
GtJavaSpringMapping >> lookupValueOf: aString from: aNode [
	| current container |
	current := aNode.
	[ current notNil ]
		whileTrue: [ container := current attributeNamed: #container ifAbsent: [  ].
			container
				ifNotNil: [ (container isKindOf: FAMIXType)
						ifTrue: [ container
								withSuperclassesDo: [ :each | 
									each attributes
										detect: [ :attr | attr name = aString ]
										ifFound: [ :attr | 
											attr gtASTNode
												ifNotNil: [ :node | 
													^ (node isKindOf: JavaInitializedVariableDeclarationNode)
														ifTrue: [ self valueOf: node initializer ]
														ifFalse: [ aString ] ] ] ] ] ].
			current := current parent ].
	aNode topParent imports
		detect: [ :each | each staticToken notNil and: [ each name name source = aString ] ]
		ifFound: [ :each | 
			(self mooseModel entityNamed: (self fullNameOf: each name nspace))
				ifNotNil: [ :t | 
					t attributes
						detect: [ :attr | attr name = aString ]
						ifFound: [ :attr | 
							attr gtASTNode
								ifNotNil: [ :node | 
									^ (node isKindOf: JavaInitializedVariableDeclarationNode)
										ifTrue: [ self valueOf: node initializer ]
										ifFalse: [ aString ] ] ] ] ].
	aNode topParent imports
		do: [ :each | 
			(each staticToken notNil
				and: [ each isKindOf: JavaTypeImportOnDemandDeclarationNode ])
				ifTrue: [ (self mooseModel entityNamed: (self fullNameOf: each name))
						ifNotNil: [ :t | 
							t attributes
								detect: [ :attr | attr name = aString ]
								ifFound: [ :attr | 
									attr gtASTNode
										ifNotNil: [ :node | 
											^ (node isKindOf: JavaInitializedVariableDeclarationNode)
												ifTrue: [ self valueOf: node initializer ]
												ifFalse: [ aString ] ] ] ] ] ].
	^ aString
]

{ #category : #private }
GtJavaSpringMapping >> lookupValueOfQualifiedName: aNode [
	(self lookupTypeFor: aNode nspace)
		ifNotNil: [ :class | 
			class attributes
				detect: [ :attr | attr name = aNode name source ]
				ifFound: [ :attr | 
					attr gtASTNode
						ifNotNil: [ :node | 
							(node isKindOf: JavaInitializedVariableDeclarationNode)
								ifTrue: [ ^ self valueOf: node initializer ] ] ] ].
	^ aNode source
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
	(aNode isKindOf: JavaStringLiteralNode)
		ifTrue: [ ^ aNode token source allButFirst allButLast ].
	(aNode isKindOf: JavaBinaryExpressionNode)
		ifTrue: [ ^ (self valueOf: aNode leftExpression) , (self valueOf: aNode rightExpression) ].
	(aNode isKindOf: JavaQualifiedNameNode)
		ifTrue: [ ^ self lookupValueOfQualifiedName: aNode ].
	(aNode isKindOf: JavaNameNode)
		ifTrue: [ ^ self lookupValueOf: aNode name source from: aNode ].
	^ aNode source
]

{ #category : #private }
GtJavaSpringMapping >> valuesIn: aNode [
	^ (aNode isKindOf: JavaElementArrayInitializerNode)
		ifTrue: [ aNode values collect: [ :each | self valueOf: each ] ]
		ifFalse: [ {self valueOf: aNode} ]
]
