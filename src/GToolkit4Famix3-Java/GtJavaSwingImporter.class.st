Class {
	#name : #GtJavaSwingImporter,
	#superclass : #Object,
	#instVars : [
		'model'
	],
	#category : #'GToolkit4Famix3-Java'
}

{ #category : #importing }
GtJavaSwingImporter >> addJavaCallsTo: allMappings [
	model allInvocations
		do: [ :each | 
			each gtASTNode
				ifNotNil: [ :ast | 
					| name |
					name := each signature.
					((#('delete' 'get' 'patch' 'post' 'put') includes: name)
						and: [ ast expressions size = 1
								and: [ (self doesName: ast receiver include: 'MockMvcRequestBuilders')
										or: [ ast receiver isNil
												and: [ ast topParent imports
														anySatisfy: [ :imp | 
															imp staticToken notNil
																and: [ self doesName: imp name include: 'MockMvcRequestBuilders' ] ] ] ] ] ])
						ifTrue: [ | call |
							call := GtJavaSpringCall new
									from: each from;
									requestType: name;
									url: (self urlFrom: ast expressions first);
									mooseModel: model;
									sourceAnchor: (self sourceAnchorFor: ast);
									propertyNamed: #ast put: ast;
									yourself.
							call candidates: (self possibleCandidatesFrom: allMappings forCall: call).
							each containerFiles first addEntity: call ].
					(name = 'exchange' and: [ ast expressions size > 2 ])
						ifTrue: [ | call |
							call := GtJavaSpringCall new
									from: each from;
									requestType: (self requestTypeFrom: ast expressions second);
									url: (self urlFrom: ast expressions first);
									mooseModel: model;
									sourceAnchor: (self sourceAnchorFor: ast);
									propertyNamed: #ast put: ast;
									yourself.
							call candidates: (self possibleCandidatesFrom: allMappings forCall: call).
							each containerFiles first addEntity: call ] ] ]
]

{ #category : #importing }
GtJavaSwingImporter >> addSpringEntities [
	| restController |
	restController := model
			entityNamed: #'org::springframework::web::bind::annotation::RestController'.
	restController ifNil: [ ^ self ].
	restController instances
		do: [ :each | 
			| controller famixFile |
			famixFile := each annotatedEntity gtASTNode
					ifNotNil: [ :node | node topParent attributeNamed: #famixFile ].
			controller := GtJavaSpringRestController new
					name: each annotatedEntity name;
					annotationInstance: each;
					mooseModel: model;
					sourceAnchor: (self sourceAnchorFor: each annotatedEntity gtASTNode);
					propertyNamed: #ast put: each annotatedEntity gtASTNode;
					buildRequests;
					yourself.
			famixFile addEntity: controller.
			each annotatedEntity methods
				do: [ :entity | 
					entity annotationInstances
						do: [ :inst | 
							| name |
							name := inst annotationType mooseName.
							((name beginsWith: 'org::springframework::web::bind::annotation::')
								and: [ name endsWith: 'Mapping' ])
								ifTrue: [ famixFile
										addEntity: (GtJavaSpringHandlerMethod new
												name: entity name;
												controller: controller;
												annotationInstance: inst;
												mooseModel: model;
												sourceAnchor: (self sourceAnchorFor: inst annotatedEntity gtASTNode);
												propertyNamed: #ast put: each annotatedEntity gtASTNode;
												buildRequests;
												yourself) ] ] ] ].
	(model entityNamed: #'org::springframework::web::bind::annotation')
		ifNotNil: [ :ns | 
			ns definedAnnotationTypes
				do: [ :type | 
					(type name endsWith: 'Mapping')
						ifTrue: [ type instances
								do: [ :each | 
									each gtJavaSpringEntity
										ifNil: [ | famixFile |
											famixFile := each annotatedEntity gtASTNode
													ifNotNil: [ :node | node topParent attributeNamed: #famixFile ].
											famixFile
												addEntity: (GtJavaSpringHandlerMethod new
														name: each annotatedEntity name;
														annotationInstance: each;
														mooseModel: model;
														sourceAnchor: (self sourceAnchorFor: each annotatedEntity gtASTNode);
														propertyNamed: #ast put: each annotatedEntity gtASTNode;
														buildRequests;
														yourself) ] ] ] ] ]
]

{ #category : #importing }
GtJavaSwingImporter >> buildSpringModel [
	| allMappings |
	self addSpringEntities.
	allMappings := model allWithType: GtJavaSpringMapping.
	self addJavaCallsTo: allMappings
]

{ #category : #testing }
GtJavaSwingImporter >> doesName: aNode include: aString [
	(aNode isKindOf: JavaNameNode)
		ifTrue: [ aNode name value = aString ifTrue: [ ^ true ].
			(aNode isKindOf: JavaQualifiedNameNode)
				ifTrue: [ ^ self doesName: aNode nspace include: aString ] ].
	^ false
]

{ #category : #importing }
GtJavaSwingImporter >> doesRequest: aMapping matchCall: call [
	aMapping
		fullPathsDo: [ :url :type | 
			((type isNil
				or: [ call requestType isNil or: [ type sameAs: call requestType ] ])
				and: [ self doesRequestUrl: url matchCallUrl: call url ]) ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #importing }
GtJavaSwingImporter >> doesRequestUrl: reqString matchCallUrl: callString [
	| regexString call |
	regexString := self regexStringForRequest: reqString.
	regexString = '.*[^/]+' ifTrue: [ ^ false ].
	call := callString readStream upTo: $?.
	(call size > 1 and: [ call last = $/ ]) ifTrue: [ call := call allButLast ].
	^ regexString asRegex matches: call
]

{ #category : #importing }
GtJavaSwingImporter >> fullNameOf: aNode [
	^ (aNode isKindOf: JavaQualifiedNameNode)
		ifTrue: [ (self fullNameOf: aNode nspace) , '::' , aNode name source ]
		ifFalse: [ aNode name source ]
]

{ #category : #importing }
GtJavaSwingImporter >> isRequest: aReq handledBy: bReq [
	aReq type = bReq type ifFalse: [ ^ false ].
	bReq
		fullPathsDo: [ :bUrl | 
			aReq
				fullPathsDo: [ :aUrl | 
					(((self regexStringForRequest: bUrl) asRegex matches: aUrl)
						and: [ (self regexStringForRequest: aUrl) size
								> (self regexStringForRequest: bUrl) size ]) ifTrue: [ ^ true ] ] ].
	^ false
]

{ #category : #accessing }
GtJavaSwingImporter >> model [
	^ model
]

{ #category : #accessing }
GtJavaSwingImporter >> model: anObject [
	model := anObject
]

{ #category : #importing }
GtJavaSwingImporter >> possibleCandidatesFrom: allMappings forCall: call [
	| possible |
	possible := allMappings
			select: [ :mapping | self doesRequest: mapping matchCall: call ].
	possible size > 1
		ifTrue: [ (possible
				reject: [ :req | 
					possible
						anySatisfy: [ :other | other ~~ req and: [ self isRequest: other handledBy: req ] ] ])
				ifNotEmpty: [ :c | ^ c ] ].
	^ possible
]

{ #category : #importing }
GtJavaSwingImporter >> regexStringForRequest: reqString [
	^ String
		streamContents: [ :stream | 
			| inStream |
			inStream := reqString readStream.
			stream << '.*'.
			[ inStream atEnd ]
				whileFalse: [ | char |
					char := inStream next.
					char = ${
						ifTrue: [ stream << '[^/]+'.
							inStream upTo: $} ]
						ifFalse: [ ('/\' includes: char)
								ifTrue: [ stream << '\' << char asString << '+' ]
								ifFalse: [ char isAlphaNumeric
										ifTrue: [ stream << char asString ]
										ifFalse: [ stream << '\' << char asString ] ] ] ] ]
]

{ #category : #importing }
GtJavaSwingImporter >> requestTypeFrom: aNode [
	| source |
	source := aNode source.
	^ (source beginsWith: 'HttpMethod.') ifTrue: [ source allButFirst: 11 ]
]

{ #category : #importing }
GtJavaSwingImporter >> sourceAnchorFor: aNode [
	^ FAMIXIndexedFileEntityAnchor
		file: (aNode topParent attributeNamed: #famixFile)
		startPos: aNode startPosition
		endPos: aNode stopPosition
		model: model
]

{ #category : #importing }
GtJavaSwingImporter >> urlFrom: aNode [
	(aNode isKindOf: JavaStringLiteralNode)
		ifTrue: [ ^ aNode token source allButFirst allButLast ].
	(aNode isKindOf: JavaBinaryExpressionNode)
		ifTrue: [ ^ (self urlFrom: aNode leftExpression) , (self urlFrom: aNode rightExpression) ].
	(aNode isKindOf: JavaQualifiedNameNode)
		ifTrue: [ ^ self urlValueOfQualifiedName: aNode ].
	(aNode isKindOf: JavaNameNode)
		ifTrue: [ ^ self urlValueOf: aNode name source from: aNode ].
	^ '{' , aNode source , '}'
]

{ #category : #importing }
GtJavaSwingImporter >> urlValueOf: aString from: aNode [
	| current container |
	current := aNode.
	[ current notNil ]
		whileTrue: [ (current attributeNamed: #locals)
				ifNotNil: [ :dict | 
					dict
						at: aString
						ifPresent: [ :var | 
							^ (var gtASTNode isKindOf: JavaInitializedVariableDeclarationNode)
								ifTrue: [ self urlFrom: var gtASTNode initializer ]
								ifFalse: [ '{' , aString , '}' ] ] ].
			container := current attributeNamed: #container ifAbsent: [  ].
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
														ifTrue: [ self urlFrom: node initializer ]
														ifFalse: [ '{' , aString , '}' ] ] ] ] ] ].
			current := current parent ].
	aNode topParent imports
		detect: [ :each | each staticToken notNil and: [ each name name source = aString ] ]
		ifFound: [ :each | 
			(model entityNamed: (self fullNameOf: each name nspace))
				ifNotNil: [ :t | 
					t attributes
						detect: [ :attr | attr name = aString ]
						ifFound: [ :attr | 
							attr gtASTNode
								ifNotNil: [ :node | 
									^ (node isKindOf: JavaInitializedVariableDeclarationNode)
										ifTrue: [ self urlFrom: node initializer ]
										ifFalse: [ '{' , aString , '}' ] ] ] ] ].
	aNode topParent imports
		do: [ :each | 
			(each staticToken notNil
				and: [ each isKindOf: JavaTypeImportOnDemandDeclarationNode ])
				ifTrue: [ (model entityNamed: (self fullNameOf: each name))
						ifNotNil: [ :t | 
							t attributes
								detect: [ :attr | attr name = aString ]
								ifFound: [ :attr | 
									attr gtASTNode
										ifNotNil: [ :node | 
											^ (node isKindOf: JavaInitializedVariableDeclarationNode)
												ifTrue: [ self urlFrom: node initializer ]
												ifFalse: [ '{' , aString , '}' ] ] ] ] ] ].
	^ '{' , aString , '}'
]

{ #category : #importing }
GtJavaSwingImporter >> urlValueOfQualifiedName: aNode [
	^ '{' , aNode source , '}'
]
