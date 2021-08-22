Extension { #name : 'CPPEnumSpecifierNode' }

{ #category : '*GToolkit4Famix3' }
CPPEnumSpecifierNode >> gtHasLinks [
	^ true
]

{ #category : '*GToolkit4Famix3' }
CPPEnumSpecifierNode >> gtLinksFor: anEntity do: aBlock [
	| start stop token |
	token := name ifNil: [ enumToken ].
	start := self preprocessedStartPositionFor: token startPosition.
	stop := self preprocessedStopPositionFor: token stopPosition.
	aBlock value: anEntity value: start value: stop
]
