Extension { #name : #CPPLambdaExpressionNode }

{ #category : #'*GToolkit4Famix3' }
CPPLambdaExpressionNode >> gtHasLinks [
	^ true
]

{ #category : #'*GToolkit4Famix3' }
CPPLambdaExpressionNode >> gtLinksFor: anEntity do: aBlock [
	aBlock
		value: anEntity
		value: (self preprocessedStartPositionFor: self arrow startPosition)
		value: (self preprocessedStopPositionFor: self arrow stopPosition)
]
