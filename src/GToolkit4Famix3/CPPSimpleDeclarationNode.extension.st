Extension { #name : #CPPSimpleDeclarationNode }

{ #category : #'*GToolkit4Famix3' }
CPPSimpleDeclarationNode >> gtHasLinks [
	^ true
]

{ #category : #'*GToolkit4Famix3' }
CPPSimpleDeclarationNode >> gtLinksFor: anEntity do: aBlock [
	(declarators notEmpty
		and: [ specifiers isEmpty
				and: [ declarators first isKindOf: CPPInitDeclaratorNode ] ])
		ifTrue: [ aBlock
				value: anEntity
				value: declarators first declarator preprocessedStartPosition
				value: declarators first declarator preprocessedStopPosition ]
		ifFalse: [ declarators notEmpty
				ifTrue: [ aBlock
						value: anEntity
						value: declarators first preprocessedStartPosition
						value: declarators last preprocessedStopPosition ]
				ifFalse: [ aBlock
						value: anEntity
						value: specifiers last preprocessedStartPosition
						value: specifiers last preprocessedStopPosition ].
			self typeLinksFor: specifiers to: anEntity declaredType do: aBlock ]
]
