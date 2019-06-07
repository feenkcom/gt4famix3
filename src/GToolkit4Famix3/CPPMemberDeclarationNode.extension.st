Extension { #name : #CPPMemberDeclarationNode }

{ #category : #'*GToolkit4Famix3' }
CPPMemberDeclarationNode >> gtHasLinks [
	^ true
]

{ #category : #'*GToolkit4Famix3' }
CPPMemberDeclarationNode >> gtLinksFor: anEntity do: aBlock [
	self declarators isEmpty
		ifTrue: [ self specifiers isEmpty
				ifTrue: [ ^ self ].
			aBlock
				value: anEntity
				value: self specifiers last preprocessedStartPosition
				value: self specifiers last preprocessedStopPosition ].
	self declarators size = 1
		ifTrue: [ self declarators first declarator
				ifNotNil: [ :declarator | 
					aBlock
						value: anEntity
						value: declarator id preprocessedStartPosition
						value: declarator id preprocessedStopPosition ] ].
	self typeLinksFor: specifiers to: anEntity declaredType do: aBlock
]
