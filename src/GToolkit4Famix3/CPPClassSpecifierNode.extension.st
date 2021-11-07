Extension { #name : #CPPClassSpecifierNode }

{ #category : #'*GToolkit4Famix3' }
CPPClassSpecifierNode >> gtHasLinks [
	^ true
]

{ #category : #'*GToolkit4Famix3' }
CPPClassSpecifierNode >> gtLinksFor: anEntity do: aBlock [
	| start stop token |
	name notNil
		ifTrue: [ start := name preprocessedStartPosition.
			stop := name preprocessedStopPosition ]
		ifFalse: [ token := classToken ifNil: [ structToken ifNil: [ unionToken ] ].
			start := self preprocessedStartPositionFor: token startPosition.
			stop := self preprocessedStopPositionFor: token stopPosition ].
	aBlock value: anEntity value: start value: stop
]
