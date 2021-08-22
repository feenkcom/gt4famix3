Extension { #name : 'CPPLabeledStatementNode' }

{ #category : '*GToolkit4Famix3' }
CPPLabeledStatementNode >> gtHasLinks [
	^ true
]

{ #category : '*GToolkit4Famix3' }
CPPLabeledStatementNode >> gtLinksFor: anEntity do: aBlock [
	aBlock
		value: anEntity
		value: self preprocessedStartPosition
		value: self preprocessedStopPosition
]
