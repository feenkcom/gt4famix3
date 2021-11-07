Extension { #name : #CPPParameterDeclarationNode }

{ #category : #'*GToolkit4Famix3' }
CPPParameterDeclarationNode >> gtHasLinks [
	^ true
]

{ #category : #'*GToolkit4Famix3' }
CPPParameterDeclarationNode >> gtLinksFor: anEntity do: aBlock [
	| var |
	var := declarator ifNil: [ specifiers last ].
	aBlock
		value: anEntity
		value: var preprocessedStartPosition
		value: var preprocessedStopPosition.
	self typeLinksFor: specifiers to: anEntity declaredType do: aBlock
]
