Extension { #name : #CPPParameterDeclarationNode }

{ #category : #'*GToolkit4Famix3' }
CPPParameterDeclarationNode >> gtHasLinks [
	^ true
]

{ #category : #'*GToolkit4Famix3' }
CPPParameterDeclarationNode >> gtLinksFor: anEntity do: aBlock [
	aBlock
		value: anEntity
		value: declarator preprocessedStartPosition
		value: declarator preprocessedStopPosition.
	self typeLinksFor: specifiers to: anEntity declaredType do: aBlock
]
