Extension { #name : 'SmaCCParseNode' }

{ #category : '*GToolkit4Famix3' }
SmaCCParseNode >> gtHasLinks [
	^ false
]

{ #category : '*GToolkit4Famix3' }
SmaCCParseNode >> gtLinksFor: anEntity do: aBlock [
	
]

{ #category : '*GToolkit4Famix3' }
SmaCCParseNode >> preprocessedStartPosition [
	^ self preprocessedStartPositionFor: self startPosition
]

{ #category : '*GToolkit4Famix3' }
SmaCCParseNode >> preprocessedStartPositionFor: anInteger [
	^ (self topParent attributeNamed: #preprocessedFile)
		ifNotNil: [ :file | file startPositionFor: anInteger ]
		ifNil: [ anInteger ]
]

{ #category : '*GToolkit4Famix3' }
SmaCCParseNode >> preprocessedStopPosition [
	^ self preprocessedStopPositionFor: self stopPosition
]

{ #category : '*GToolkit4Famix3' }
SmaCCParseNode >> preprocessedStopPositionFor: anInteger [
	^ (self topParent attributeNamed: #preprocessedFile)
		ifNotNil: [ :file | file stopPositionFor: anInteger ]
		ifNil: [ anInteger ]
]
