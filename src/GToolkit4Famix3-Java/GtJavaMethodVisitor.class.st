Class {
	#name : #GtJavaMethodVisitor,
	#superclass : #Object,
	#traits : 'TJavaProgramNodeVisitor',
	#classTraits : 'TJavaProgramNodeVisitor classTrait',
	#instVars : [
		'importer',
		'insideMethod'
	],
	#category : #'GToolkit4Famix3-Java'
}

{ #category : #visiting }
GtJavaMethodVisitor >> acceptNode: aSmaCCParseNode [
	| previous |
	aSmaCCParseNode isNil ifTrue: [ ^ nil ].
	previous := insideMethod.
	insideMethod
		ifFalse: [ (importer methodNodeFor: aSmaCCParseNode)
				ifNil: [ ^ self visitSmaCCParseNode: aSmaCCParseNode ].
			insideMethod := true ].
	^ [ aSmaCCParseNode acceptVisitor: self ] ensure: [ insideMethod := previous ]
]

{ #category : #accessing }
GtJavaMethodVisitor >> allMethodTypesFor: aNode do: aBlock [
	(aNode
		nodeOfType: {JavaClassDeclarationNode.
				JavaInterfaceDeclarationNode.
				JavaNewClassNode})
		ifNotNil: [ :node | 
			(node attributeNamed: #container ifAbsent: [  ]) ifNotNil: aBlock.
			node parent ifNotNil: [ self allMethodTypesFor: node parent do: aBlock ] ]
]

{ #category : #accessing }
GtJavaMethodVisitor >> createMethodInvocation: aMethodInvocation [
	| invocation famixFile returnType |
	famixFile := aMethodInvocation topParent attributeNamed: #famixFile.
	invocation := FAMIXInvocation new
			signature: aMethodInvocation name source;
			sourceAnchor: (importer sourceAnchorFor: aMethodInvocation);
			mooseModel: importer model;
			propertyNamed: #ast put: aMethodInvocation;
			yourself.
	aMethodInvocation receiver
		ifNotNil: [ invocation receiverSourceCode: aMethodInvocation receiver source ].
	(importer methodNodeFor: aMethodInvocation)
		ifNotNil: [ :n | 
			(n attributeNamed: #container ifAbsent: [  ])
				ifNotNil: [ :c | invocation sender: c ] ].
	aMethodInvocation attributeNamed: #invocation put: invocation.
	famixFile addEntity: invocation.
	(self potentialImplementersIn: aMethodInvocation)
		do: [ :each | invocation addCandidate: each ].
	invocation candidates
		do: [ :each | 
			returnType
				ifNil: [ each declaredType ]
				ifNotNil: [ returnType ~~ each declaredType ifTrue: [ ^ self ] ] ].
	returnType
		ifNotNil: [ aMethodInvocation attributeNamed: #type put: returnType ]
]

{ #category : #accessing }
GtJavaMethodVisitor >> implementersOf: aMethodInvocation in: cls [
	^ cls methods
		select: [ :each | 
			each name = aMethodInvocation name source
				and: [ aMethodInvocation arguments size <= each parameters size ] ]
]

{ #category : #accessing }
GtJavaMethodVisitor >> importer [
	^ importer
]

{ #category : #accessing }
GtJavaMethodVisitor >> importer: anObject [
	importer := anObject
]

{ #category : #accessing }
GtJavaMethodVisitor >> initialize [
	super initialize.
	insideMethod := false
]

{ #category : #accessing }
GtJavaMethodVisitor >> lookupAttribute: aName [
	self
		allMethodTypesFor: aName
		do: [ :t | (self lookupAttributeNamed: aName name source in: t) ifNotNil: [ :v | ^ v ] ].
	^ nil
]

{ #category : #accessing }
GtJavaMethodVisitor >> lookupAttributeNamed: aString in: aType [
	(aType isKindOf: FAMIXNamespace)
		ifTrue: [ aType children do: [ :attr | attr name = aString ifTrue: [ ^ attr ] ] ]
		ifFalse: [ aType
				withSuperclassesDo: [ :each | each attributes do: [ :attr | attr name = aString ifTrue: [ ^ attr ] ] ] ].
	(aType isKindOf: FAMIXEnum)
		ifTrue: [ aType values
				detect: [ :each | each name = aString ]
				ifFound: [ :each | ^ each ] ].
	^ nil
]

{ #category : #accessing }
GtJavaMethodVisitor >> lookupImported: aName [
	| varName |
	varName := aName name source.
	aName topParent packageDeclaration
		ifNotNil: [ (aName topParent attributeNamed: #container) children
				detect: [ :each | each name = varName and: [ each isKindOf: FAMIXStructuralEntity ] ]
				ifFound: [ :each | ^ each ] ].
	aName topParent imports
		do: [ :each | 
			each class = JavaSingleTypeImportDeclarationNode
				ifTrue: [ each name name source = varName
						ifTrue: [ | ns |
							ns := each name nspace name source first isUppercase
									ifTrue: [ importer lookupType: each name nspace ]
									ifFalse: [ importer ensureNamespaceFrom: each name nspace ].
							ns children
								detect: [ :e | e name = varName ]
								ifFound: [ :e | ^ e ]
								ifNone: [ (ns isKindOf: FAMIXType)
										ifTrue: [ ^ FAMIXAttribute new
												name: varName;
												parentType: ns;
												mooseModel: importer model;
												isStub: true;
												yourself ]
										ifFalse: [ ns
												ifNotNil: [ ^ importer lookupTypeNamed: varName inContainer: ns ] ] ] ] ] ].
	^ nil
]

{ #category : #accessing }
GtJavaMethodVisitor >> lookupLocal: aName [
	| current |
	current := aName.
	[ current notNil ]
		whileTrue: [ (current attributeNamed: #locals ifAbsent: [  ])
				ifNotNil: [ :dict | dict at: aName name source ifPresent: [ :each | ^ each ] ].
			current := current parent ].
	^ nil
]

{ #category : #accessing }
GtJavaMethodVisitor >> methodTypeFor: aNode [
	^ (aNode
		nodeOfType: {JavaClassDeclarationNode.
				JavaInterfaceDeclarationNode.
				JavaNewClassNode.
				JavaEnumDeclarationNode})
		ifNotNil: [ :node | node attributeNamed: #container ifAbsent: [  ] ]
]

{ #category : #accessing }
GtJavaMethodVisitor >> potentialImplementersIn: aMethodInvocation [
	| impls |
	impls := Set new.
	(aMethodInvocation receiver
		ifNil: [ self methodTypeFor: aMethodInvocation ]
		ifNotNil: [ :r | r attributeNamed: #type ])
		ifNotNil: [ :type | 
			type
				allSubclassesDo: [ :cls | impls addAll: (self implementersOf: aMethodInvocation in: cls) ].
			type
				withSuperclassesDo: [ :cls | 
					(self implementersOf: aMethodInvocation in: cls)
						ifNotEmpty: [ :col | 
							impls addAll: col.
							^ impls ] ] ].
	^ impls
]

{ #category : #accessing }
GtJavaMethodVisitor >> superVariableFor: aName [
	| type |
	type := self methodTypeFor: aName.
	type ifNil: [ ^ nil ].
	^ type attributes
		detect: [ :each | each name = 'super' ]
		ifNone: [ FAMIXImplicitVariable new
				name: 'super';
				mooseModel: importer model;
				declaredType: type superclass;
				parentBehaviouralEntity: (importer containerIn: aName);
				yourself ]
]

{ #category : #accessing }
GtJavaMethodVisitor >> thisVariableFor: aName [
	| type |
	type := self methodTypeFor: aName.
	type ifNil: [ ^ nil ].
	^ type attributes
		detect: [ :each | each name = 'this' ]
		ifNone: [ FAMIXImplicitVariable new
				name: 'this';
				mooseModel: importer model;
				declaredType: type;
				parentBehaviouralEntity: (importer
						containerIn: aName
						matching: [ :c | c isKindOf: FAMIXBehaviouralEntity ]);
				yourself ]
]

{ #category : #accessing }
GtJavaMethodVisitor >> visitFieldAccess: aFieldAccess [
	| access |
	self visitExpression: aFieldAccess.
	access := FAMIXAccess new
			sourceAnchor: (importer sourceAnchorFor: aFieldAccess);
			mooseModel: importer model;
			propertyNamed: #ast put: aFieldAccess;
			yourself.
	(importer methodNodeFor: aFieldAccess)
		ifNotNil: [ :n | (n attributeNamed: #container ifAbsent: [  ]) ifNotNil: [ :c | access from: c ] ].
	(aFieldAccess receiver
		ifNil: [ | superAccess |
			superAccess := FAMIXAccess new
					sourceAnchor: (FAMIXIndexedFileEntityAnchor
							file: (aFieldAccess topParent attributeNamed: #famixFile)
							startPos: aFieldAccess superToken startPosition
							endPos: aFieldAccess superToken stopPosition
							model: importer model);
					mooseModel: importer model;
					yourself.
			(importer methodNodeFor: aFieldAccess)
				ifNotNil: [ :n | 
					(n attributeNamed: #container ifAbsent: [  ])
						ifNotNil: [ :c | superAccess from: c ] ].
			superAccess to: (self superVariableFor: aFieldAccess).
			superAccess to declaredType ]
		ifNotNil: [ aFieldAccess receiver attributeNamed: #type ifAbsent: [  ] ])
		ifNotNil: [ :t | 
			(self lookupAttributeNamed: aFieldAccess name source in: t)
				ifNotNil: [ :var | access to: var ] ].
	access to
		ifNotNil: [ access to declaredType
				ifNotNil: [ :type | aFieldAccess attributeNamed: #type put: type ] ]
]

{ #category : #accessing }
GtJavaMethodVisitor >> visitMethodInvocation: aMethodInvocation [
	self visitExpression: aMethodInvocation.
	self createMethodInvocation: aMethodInvocation
]

{ #category : #accessing }
GtJavaMethodVisitor >> visitName: aName [
	| access toVar ref |
	aName name source = 'this'
		ifTrue: [ toVar := self thisVariableFor: aName ]
		ifFalse: [ aName name source = 'super'
				ifTrue: [ toVar := self superVariableFor: aName ]
				ifFalse: [ ((self lookupLocal: aName)
						ifNil: [ (self lookupAttribute: aName) ifNil: [ self lookupImported: aName ] ])
						ifNotNil: [ :var | 
							(var isKindOf: FAMIXStructuralEntity)
								ifTrue: [ toVar := var ]
								ifFalse: [ aName attributeNamed: #type put: var.
									^ (var isKindOf: FAMIXType)
										ifTrue: [ ref := FAMIXReference new
													to: var;
													sourceAnchor: (importer sourceAnchorFor: aName);
													mooseModel: importer model;
													propertyNamed: #ast put: aName;
													yourself.
											(importer methodNodeFor: aName)
												ifNotNil: [ :n | (n attributeNamed: #container ifAbsent: [  ]) ifNotNil: [ :c | ref from: c ] ].
											ref ] ] ] ] ].
	access := FAMIXAccess new
			to: toVar;
			sourceAnchor: (importer sourceAnchorFor: aName);
			mooseModel: importer model;
			propertyNamed: #ast put: aName;
			yourself.
	(importer methodNodeFor: aName)
		ifNotNil: [ :n | (n attributeNamed: #container ifAbsent: [  ]) ifNotNil: [ :c | access from: c ] ].
	access to
		ifNotNil: [ access to declaredType
				ifNotNil: [ :type | aName attributeNamed: #type put: type ] ].
	^ self visitExpression: aName
]

{ #category : #accessing }
GtJavaMethodVisitor >> visitQualifiedName: aQualifiedName [
	| access toVar ref |
	self visitExpression: aQualifiedName.
	(aQualifiedName nspace attributeNamed: #type ifAbsent: [  ])
		ifNotNil: [ :t | 
			(self lookupAttributeNamed: aQualifiedName name source in: t)
				ifNotNil: [ :var | 
					(var isKindOf: FAMIXStructuralEntity)
						ifTrue: [ toVar := var ]
						ifFalse: [ (var isKindOf: FAMIXType)
								ifTrue: [ ref := FAMIXReference new
											to: var;
											sourceAnchor: (importer sourceAnchorFor: aQualifiedName);
											mooseModel: importer model;
											propertyNamed: #ast put: aQualifiedName;
											yourself.
									(importer methodNodeFor: aQualifiedName)
										ifNotNil: [ :n | (n attributeNamed: #container ifAbsent: [  ]) ifNotNil: [ :c | ref from: c ] ].
									^ ref ].
							^ aQualifiedName attributeNamed: #type put: var ] ] ].
	access := FAMIXAccess new
			to: toVar;
			sourceAnchor: (importer sourceAnchorFor: aQualifiedName);
			mooseModel: importer model;
			propertyNamed: #ast put: aQualifiedName;
			yourself.
	(importer methodNodeFor: aQualifiedName)
		ifNotNil: [ :n | (n attributeNamed: #container ifAbsent: [  ]) ifNotNil: [ :c | access from: c ] ].
	access to
		ifNotNil: [ access to declaredType
				ifNotNil: [ :type | aQualifiedName attributeNamed: #type put: type ] ]
]
