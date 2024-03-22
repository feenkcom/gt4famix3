Class {
	#name : #GtJSSwaggerImporter,
	#superclass : #Object,
	#instVars : [
		'model'
	],
	#category : #'GToolkit4Famix3-JavaScript'
}

{ #category : #accessing }
GtJSSwaggerImporter >> addSwaggerCandidatesTo: aSwaggerCall [
	| items |
	aSwaggerCall url isEmpty
		ifTrue: [ items := #() ]
		ifFalse: [ items := self
					filterBestSwaggerCandidates: ((model allWithType: GtJSSwaggerHandler)
							select: [ :each | self doesHandler: each matchCall: aSwaggerCall ]) ].
	aSwaggerCall candidates: items
]

{ #category : #accessing }
GtJSSwaggerImporter >> buildSwaggerModel [
	self importSwaggerHandlers.
	self importSwaggerCalls
]

{ #category : #accessing }
GtJSSwaggerImporter >> commonLengthBetween: a and: b [
	^ (1 to: (a size min: b size))
		detect: [ :i | (a at: i) ~= (b at: i) ]
		ifNone: [ (a size min: b size) + 1 ]
]

{ #category : #accessing }
GtJSSwaggerImporter >> copySourceAnchorFrom: call [
	| newAnchor oldAnchor |
	oldAnchor := call sourceAnchor.
	oldAnchor ifNil: [ ^ nil ].
	newAnchor := oldAnchor copy.
	^ newAnchor
]

{ #category : #accessing }
GtJSSwaggerImporter >> doesHandler: aHandler matchCall: call [
	aHandler
		fullPathsDo: [ :url :type | 
			((type isNil
				or: [ call requestType isNil or: [ type sameAs: call requestType ] ])
				and: [ self doesHandlerUrl: url matchCallUrl: call url ]) ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #accessing }
GtJSSwaggerImporter >> doesHandlerUrl: reqString matchCallUrl: callString [
	| regexString call |
	(self doesUrlHaveCharacter: reqString) ifFalse: [ ^ false ].
	regexString := self regexStringForRequest: reqString.
	regexString = '.*[^/]+' ifTrue: [ ^ false ].
	call := callString readStream upTo: $?.
	(call size > 1 and: [ call last = $/ ]) ifTrue: [ call := call allButLast ].
	^ regexString asRegex matches: call
]

{ #category : #accessing }
GtJSSwaggerImporter >> doesUrlHaveCharacter: reqString [
	| stream ch |
	stream := reqString readStream.
	[ stream atEnd ]
		whileFalse: [ ch := stream next.
			ch = $/ ifFalse: [ ch = ${ ifTrue: [ stream upTo: $} ] ifFalse: [ ^ true ] ] ].
	^ false
]

{ #category : #accessing }
GtJSSwaggerImporter >> encodedUrlFrom: aString [
	^ String
		streamContents: [ :stream | 
			| in c |
			in := aString readStream.
			[ in atEnd ]
				whileFalse: [ stream nextPutAll: (in upTo: $:).
					in atEnd
						ifFalse: [ stream nextPut: ${.
							[ in atEnd not
								and: [ c := in next.
									c ~= $/ ] ] whileTrue: [ stream nextPut: c ].
							stream nextPut: $}.
							c = $/ ifTrue: [ stream nextPut: $/ ] ] ] ]
]

{ #category : #accessing }
GtJSSwaggerImporter >> filterBestSwaggerCandidates: handlers [
	handlers size > 1
		ifTrue: [ (handlers
				reject: [ :req | 
					handlers
						anySatisfy: [ :other | other ~~ req and: [ self isRequest: other handledBy: req ] ] ])
				ifNotEmpty: [ :c | ^ c ] ].
	^ handlers
]

{ #category : #accessing }
GtJSSwaggerImporter >> findAssignmentOf: aString from: aNode [
	| current obj var |
	current := aNode.
	[ var isNil and: [ current notNil ] ]
		whileTrue: [ obj := current attributeNamed: #modelObject ifAbsent: [  ].
			(obj isKindOf: FAMIXBehaviouralEntity)
				ifTrue: [ obj localVariables
						detect: [ :each | each name = aString ]
						ifFound: [ :each | var := each ] ].
			(obj isKindOf: FAMIXType)
				ifTrue: [ obj attributes
						detect: [ :each | each name = aString ]
						ifFound: [ :each | var := each ] ].
			current := current parent ].
	var
		ifNotNil: [ var incomingAccesses do: [ :each | each isWrite ifTrue: [ ^ each gtASTNode ] ] ].
	^ nil
]

{ #category : #accessing }
GtJSSwaggerImporter >> getQueryNameFrom: ast or: url [
	| index in parentCall ch queryString |
	queryString := ''.
	index := url indexOfSubCollection: '?query={'.
	index > 0
		ifTrue: [ queryString := url allButFirst: index + 7 ]
		ifFalse: [ index := url indexOfSubCollection: '/graph/graphql/'.
			index > 0
				ifTrue: [ queryString := url allButFirst: index + 14 ]
				ifFalse: [ ((ast parent isKindOf: JSNamedPropertyExpressionNode)
						and: [ ast parent name source = 'send'
								and: [ ((parentCall := ast parent parent) isKindOf: JSCallExpressionNode)
										and: [ parentCall arguments size >= 1
												and: [ parentCall arguments first isKindOf: JSObjectLiteralNode ] ] ] ])
						ifTrue: [ parentCall arguments first definitions
								do: [ :def | 
									((def isKindOf: JSPropertyAssignmentNode) and: [ def name source = 'query' ])
										ifTrue: [ queryString := self urlFrom: def value ] ] ] ] ].

	^ String
		streamContents: [ :stream | 
			in := queryString readStream.
			[ in atEnd not and: [ in peek isAlphaNumeric not ] ] whileTrue: [ in next ].
			[ in atEnd not and: [ (ch := in next) isAlphaNumeric ] ]
				whileTrue: [ stream nextPut: ch ] ]
]

{ #category : #accessing }
GtJSSwaggerImporter >> importSwaggerCalls [
	self
		swaggerCallsDo: [ :call :url :type | 
			self
				addSwaggerCandidatesTo: (GtJSSwaggerCall new
						caller: call sender;
						url: url;
						requestType: type;
						sourceAnchor: (self copySourceAnchorFrom: call);
						mooseModel: model) ]
]

{ #category : #accessing }
GtJSSwaggerImporter >> importSwaggerHandlers [
	model allAnnotationTypes
		do: [ :type | 
			(#('Controller' 'JsonController') includes: type name)
				ifTrue: [ type instances
						do: [ :each | 
							GtJSSwaggerController new
								annotationInstance: each;
								mooseModel: model ] ] ].
	#('Delete' 'Get' 'Patch' 'Post' 'Put')
		do: [ :name | 
			model allAnnotationTypes
				do: [ :type | 
					type name = name
						ifTrue: [ type instances
								do: [ :each | 
									GtJSSwaggerHandler new
										annotationInstance: each;
										mooseModel: model;
										propertyNamed: #ast put: each gtASTNode;
										type: name asUppercase;
										urls: (self urlsFor: each gtASTNode expression) ] ] ] ]
]

{ #category : #accessing }
GtJSSwaggerImporter >> isRequest: aReq handledBy: bReq [
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
GtJSSwaggerImporter >> model [
	^ model
]

{ #category : #accessing }
GtJSSwaggerImporter >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtJSSwaggerImporter >> regexStringForRequest: reqString [
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

{ #category : #accessing }
GtJSSwaggerImporter >> swaggerCallsDo: aBlock [
	#('delete' 'get' 'patch' 'post' 'put')
		do: [ :type | 
			((model allAttributes select: [ :each | each name = type ])
				flatCollect: [ :each | each receivingInvocations ])
				do: [ :inv | 
					| ast source |
					ast := inv gtASTNode.
					(ast arguments size = 1
						and: [ source := ast expression source.
							('*http*' match: source) or: [ '*request*' match: source ] ])
						ifTrue: [ aBlock
								value: inv
								value: (self urlFrom: ast arguments first)
								value: type asUppercase ] ] ]
]

{ #category : #accessing }
GtJSSwaggerImporter >> urlFrom: aNode [
	(aNode isKindOf: JSStringLiteralNode)
		ifTrue: [ ^ aNode source allButFirst allButLast ].
	(aNode isKindOf: JSTemplateLiteralNode)
		ifTrue: [ ^ aNode source allButFirst allButLast copyReplaceAll: '${' with: '{' ].
	(aNode isKindOf: JSNameExpressionNode)
		ifTrue: [ (self findAssignmentOf: aNode name source from: aNode)
				ifNotNil: [ :assign | ^ self urlFrom: assign value ] ].
	(aNode isKindOf: JSNamedPropertyExpressionNode)
		ifTrue: [ (aNode expression isKindOf: JSNameExpressionNode)
				ifTrue: [ ^ self urlFromPropertyExpression: aNode ] ].
	^ '{' , aNode source , '}'
]

{ #category : #accessing }
GtJSSwaggerImporter >> urlFromPropertyExpression: aNode [
	| possible filename |
	filename := aNode topParent filename pathString.
	possible := (model allTypes
			select: [ :each | each name = aNode expression name source ])
			asSortedCollection: [ :a :b | 
				(self
					commonLengthBetween: a gtASTNode topParent filename pathString
					and: filename)
					> (self
							commonLengthBetween: b gtASTNode topParent filename pathString
							and: filename) ].
	possible
		do: [ :each | 
			(each isKindOf: FAMIXEnum)
				ifTrue: [ each values
						do: [ :ev | 
							ev name = aNode name value
								ifTrue: [ ev gtASTNode value ifNotNil: [ :v | ^ self urlFrom: v ] ] ] ] ].
	^ '{' , aNode source , '}'
]

{ #category : #accessing }
GtJSSwaggerImporter >> urlsFor: aNode [
	| arg |
	((aNode isKindOf: JSCallExpressionNode) and: [ aNode arguments size > 0 ])
		ifTrue: [ arg := aNode arguments first.
			(arg isKindOf: JSStringLiteralNode)
				ifTrue: [ ^ {self encodedUrlFrom: arg value source allButFirst allButLast} ].
			(arg isKindOf: JSArrayLiteralNode)
				ifTrue: [ ^ arg expressions
						collect: [ :each | 
							(each isKindOf: JSStringLiteralNode)
								ifTrue: [ self encodedUrlFrom: each value source allButFirst allButLast ]
								ifFalse: [ '{' , each source , '}' ] ] ] ].
	^ {'{' , aNode source , '}'}
]
