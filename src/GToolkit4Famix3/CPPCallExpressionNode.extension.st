Extension { #name : #CPPCallExpressionNode }

{ #category : #'*GToolkit4Famix3' }
CPPCallExpressionNode >> gtHasLinks [
	^ true
]

{ #category : #'*GToolkit4Famix3' }
CPPCallExpressionNode >> gtLinksFor: anEntity do: aBlock [
	| id |
	id := expression.
	[ id isKindOf: CPPMemberExpressionNode ] whileTrue: [ id := id id ].
	aBlock
		value: anEntity
		value: id preprocessedStartPosition
		value: id preprocessedStopPosition
]
