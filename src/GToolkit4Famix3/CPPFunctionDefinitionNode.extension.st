Extension { #name : #CPPFunctionDefinitionNode }

{ #category : #'*GToolkit4Famix3' }
CPPFunctionDefinitionNode >> gtHasLinks [
	^ true
]

{ #category : #'*GToolkit4Famix3' }
CPPFunctionDefinitionNode >> gtLinksFor: anEntity do: aBlock [
	| entity |
	entity := ((anEntity isKindOf: FAMIXCPPMethodImplementation)
		or: [ anEntity isKindOf: FAMIXCPPMethodDeclaration ])
		ifTrue: [ anEntity method ]
		ifFalse: [ anEntity ].
	aBlock
		value: entity
		value: self declarator id preprocessedStartPosition
		value: self declarator id preprocessedStopPosition.
	self typeLinksFor: specifiers to: entity declaredType do: aBlock.
	(entity isMethod and: [ entity declaration notNil ])
		ifTrue: [ declarator declarations
				with: entity parameters
				do: [ :node :parm | node gtLinksFor: parm do: aBlock ] ]
]
