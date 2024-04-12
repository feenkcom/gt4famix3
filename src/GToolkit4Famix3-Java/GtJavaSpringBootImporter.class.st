Class {
	#name : #GtJavaSpringBootImporter,
	#superclass : #Object,
	#instVars : [
		'model'
	],
	#category : #'GToolkit4Famix3-Java'
}

{ #category : #importing }
GtJavaSpringBootImporter >> addJavaCallsTo: allMappings [
	self
		springBootCallsDo: [ :invocation :url :type :accept :contentType | 
			| call |
			call := GtJavaSpringCall new
					from: invocation from;
					requestType: type;
					accepts: accept;
					contentType: contentType;
					url: url;
					mooseModel: model;
					sourceAnchor: (self sourceAnchorFor: invocation gtASTNode);
					propertyNamed: #ast put: invocation gtASTNode;
					yourself.
			call candidates: (self possibleCandidatesFrom: allMappings forCall: call).
			invocation containerFiles first addEntity: call ]
]

{ #category : #importing }
GtJavaSpringBootImporter >> addSpringEntities [
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
GtJavaSpringBootImporter >> buildSpringModel [
	| allMappings |
	self addSpringEntities.
	allMappings := model allWithType: GtJavaSpringMapping.
	self addJavaCallsTo: allMappings
]

{ #category : #testing }
GtJavaSpringBootImporter >> doesName: aNode include: aString [
	(aNode isKindOf: JavaNameNode)
		ifTrue: [ aNode name value = aString ifTrue: [ ^ true ].
			(aNode isKindOf: JavaQualifiedNameNode)
				ifTrue: [ ^ self doesName: aNode nspace include: aString ] ].
	^ false
]

{ #category : #importing }
GtJavaSpringBootImporter >> doesRequest: aMapping matchCall: call [
	aMapping
		fullPathsDo: [ :url :type | 
			((type isNil
				or: [ call requestType isNil or: [ type sameAs: call requestType ] ])
				and: [ self doesRequestUrl: url matchCallUrl: call url ]) ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #importing }
GtJavaSpringBootImporter >> doesRequestUrl: reqString matchCallUrl: callString [
	| regexString call |
	regexString := self regexStringForRequest: reqString.
	regexString = '.*[^/]+' ifTrue: [ ^ false ].
	call := callString readStream upTo: $?.
	(call size > 1 and: [ call last = $/ ]) ifTrue: [ call := call allButLast ].
	^ regexString asRegex matches: call
]

{ #category : #importing }
GtJavaSpringBootImporter >> fullNameOf: aNode [
	^ (aNode isKindOf: JavaQualifiedNameNode)
		ifTrue: [ (self fullNameOf: aNode nspace) , '::' , aNode name source ]
		ifFalse: [ aNode name source ]
]

{ #category : #importing }
GtJavaSpringBootImporter >> getAcceptFromBuilder: ast [
	| current |
	current := ast.
	[ current isKindOf: JavaMethodInvocationNode ]
		whileTrue: [ (current name value = 'accept' and: [ current expressions size = 1 ])
				ifTrue: [ ^ self valueOf: current expressions first ].
			(current name value = 'header'
				and: [ current expressions size = 2
						and: [ (GtSmaCCJavaImporter valueOf: current expressions first in: model) = 'Accept' ] ])
				ifTrue: [ ^ self valueOf: current expressions second ].
			((current parent isKindOf: JavaMethodInvocationNode)
				and: [ current parent receiver == current ])
				ifTrue: [ current := current parent ]
				ifFalse: [ current := nil ] ].
	^ nil
]

{ #category : #importing }
GtJavaSpringBootImporter >> getAcceptFromExchange: ast [
	(ast parentOfType: JavaMethodDeclarationNode)
		ifNotNil: [ :method | 
			| accept |
			method
				allNodesOfType: JavaMethodInvocationNode
				do: [ :inv | 
					inv name value = 'setAccept'
						ifTrue: [ accept ifNil: [ accept := inv ] ifNotNil: [ ^ nil ] ] ].
			accept
				ifNotNil: [ accept
						allNodesOfType: JavaMethodInvocationNode
						do: [ :inv | inv name value = 'valueOf' ifTrue: [ ^ self valueOf: inv ] ] ] ].
	^ nil
]

{ #category : #importing }
GtJavaSpringBootImporter >> getContentTypeFromBuilder: ast [
	| current |
	current := ast.
	[ current isKindOf: JavaMethodInvocationNode ]
		whileTrue: [ (current name value = 'contentType' and: [ current expressions size = 1 ])
				ifTrue: [ ^ self valueOf: current expressions first ].
			(current name value = 'header'
				and: [ current expressions size = 2
						and: [ (GtSmaCCJavaImporter valueOf: current expressions first in: model)
								= 'ContentType' ] ])
				ifTrue: [ ^ self valueOf: current expressions second ].
			((current parent isKindOf: JavaMethodInvocationNode)
				and: [ current parent receiver == current ])
				ifTrue: [ current := current parent ]
				ifFalse: [ current := nil ] ].
	^ nil
]

{ #category : #importing }
GtJavaSpringBootImporter >> getContentTypeFromExchange: ast [
	(ast parentOfType: JavaMethodDeclarationNode)
		ifNotNil: [ :method | 
			| contentType |
			method
				allNodesOfType: JavaMethodInvocationNode
				do: [ :inv | 
					inv name value = 'setContentType'
						ifTrue: [ contentType ifNil: [ contentType := inv ] ifNotNil: [ ^ nil ] ] ].
			contentType
				ifNotNil: [ contentType
						allNodesOfType: JavaMethodInvocationNode
						do: [ :inv | inv name value = 'valueOf' ifTrue: [ ^ self valueOf: inv ] ] ] ].
	^ nil
]

{ #category : #importing }
GtJavaSpringBootImporter >> isRequest: aReq handledBy: bReq [
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
GtJavaSpringBootImporter >> model [
	^ model
]

{ #category : #accessing }
GtJavaSpringBootImporter >> model: anObject [
	model := anObject
]

{ #category : #importing }
GtJavaSpringBootImporter >> possibleCandidatesFrom: allMappings forCall: call [
	| possible |
	possible := allMappings
			select: [ :mapping | self doesRequest: mapping matchCall: call ].
	possible size > 1
		ifTrue: [ (possible
				reject: [ :req | 
					possible
						anySatisfy: [ :other | other ~~ req and: [ self isRequest: other handledBy: req ] ] ])
				ifNotEmpty: [ :c | ^ c ] ].
	^ (possible
		select: [ :each | 
			(call contentType isNil
				or: [ each consumes isEmpty
						or: [ each consumes anySatisfy: [ :e | e sameAs: call contentType ] ] ])
				and: [ call accepts isNil
						or: [ each produces isEmpty
								or: [ each produces anySatisfy: [ :e | e sameAs: call accepts ] ] ] ] ])
		ifEmpty: [ possible ]
]

{ #category : #importing }
GtJavaSpringBootImporter >> regexStringForRequest: reqString [
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
GtJavaSpringBootImporter >> requestTypeFrom: aNode [
	| source |
	source := aNode source.
	^ (source beginsWith: 'HttpMethod.') ifTrue: [ source allButFirst: 11 ]
]

{ #category : #importing }
GtJavaSpringBootImporter >> sourceAnchorFor: aNode [
	^ FAMIXIndexedFileEntityAnchor
		file: (aNode topParent attributeNamed: #famixFile)
		startPos: aNode startPosition
		endPos: aNode stopPosition
		model: model
]

{ #category : #importing }
GtJavaSpringBootImporter >> springBootCallsDo: aBlock [
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
						ifTrue: [ aBlock
								valueWithPossibleArgs: {each.
										self urlFrom: ast expressions first.
										name.
										self getAcceptFromBuilder: ast.
										self getContentTypeFromBuilder: ast} ].
					(name = 'exchange' and: [ ast expressions size > 2 ])
						ifTrue: [ aBlock
								valueWithPossibleArgs: {each.
										self urlFrom: ast expressions first.
										self requestTypeFrom: ast expressions second.
										self getAcceptFromExchange: ast.
										self getContentTypeFromExchange: ast} ] ] ]
]

{ #category : #importing }
GtJavaSpringBootImporter >> urlFrom: aNode [
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
GtJavaSpringBootImporter >> urlValueOf: aString from: aNode [
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
GtJavaSpringBootImporter >> urlValueOfQualifiedName: aNode [
	^ '{' , aNode source , '}'
]

{ #category : #importing }
GtJavaSpringBootImporter >> valueOf: aNode [
	((aNode isKindOf: JavaMethodInvocationNode)
		and: [ aNode name source = 'valueOf' and: [ aNode expressions size = 1 ] ])
		ifTrue: [ ^ GtSmaCCJavaImporter valueOf: aNode expressions first in: model ].
	^ GtSmaCCJavaImporter valueOf: aNode in: model
]
