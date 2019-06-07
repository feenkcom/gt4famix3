Extension { #name : #CPPProgramNode }

{ #category : #'*GToolkit4Famix3' }
CPPProgramNode >> preprocessedStartPosition [
	^ self preprocessedStartPositionFor: self startPosition
]

{ #category : #'*GToolkit4Famix3' }
CPPProgramNode >> preprocessedStartPositionFor: anInteger [
	^ (self topParent attributeNamed: #preprocessedFile)
		ifNotNil: [ :file | file startPositionFor: anInteger ]
		ifNil: [ anInteger ]
]

{ #category : #'*GToolkit4Famix3' }
CPPProgramNode >> preprocessedStopPosition [
	^ self preprocessedStopPositionFor: self stopPosition
]

{ #category : #'*GToolkit4Famix3' }
CPPProgramNode >> preprocessedStopPositionFor: anInteger [
	^ (self topParent attributeNamed: #preprocessedFile)
		ifNotNil: [ :file | file stopPositionFor: anInteger ]
		ifNil: [ anInteger ]
]

{ #category : #'*GToolkit4Famix3' }
CPPProgramNode >> typeLinksFor: specifiers to: anEntity do: aBlock [
	| first last |
	specifiers
		detect: [ :each | 
			| done |
			done := false.
			(each isKindOf: CPPClassSpecifierNode)
				ifTrue: [ first := last := each.
					done := true ].
			(each isKindOf: CPPPrimitiveTypeNode)
				ifTrue: [ first := last := each.
					done := true ].
			(each isKindOf: CPPClassTypeNode)
				ifTrue: [ first isNil
						ifTrue: [ first := each ]
						ifFalse: [ (each source beginsWith: '::')
								ifTrue: [ last := each ]
								ifFalse: [ done := true ] ] ].
			done ]
		ifNone: [  ].
	first isNil
		ifTrue: [ ^ self ].
	last isNil
		ifTrue: [ last := first ].
	aBlock
		value: anEntity
		value: first preprocessedStartPosition
		value: last preprocessedStopPosition
]
