Extension { #name : #JSNameExpressionNode }

{ #category : #'*GToolkit4Famix3-JavaScript' }
JSNameExpressionNode >> isVariableReference [
	((parent isKindOf: JSPropertyAssignmentNode)
		and: [ self == parent name ])
		ifTrue: [ ^ false ].
	(parent isKindOf: JSObjectLiteralNode)
		ifTrue: [ ^ false ].
	(((parent isKindOf: JSFunctionNode)
		or: [ (parent isKindOf: JSMethodDefinitionNode)
				or: [ parent isKindOf: JSClassExpressionNode ] ])
		and: [ parent name == self ])
		ifTrue: [ ^ false ].
	(self parentOfType: JSClassExpressionNode)
		ifNotNil: [ :cls | 
			cls superclass notNil
				ifTrue: [ (self isDescendantFrom: cls superclass)
						ifTrue: [ ^ false ] ].
			cls types
				do: [ :each | 
					(self isDescendantFrom: each)
						ifTrue: [ ^ false ] ] ].
	^ (parent isKindOf: JSVariableDeclarationNode) not
		and: [ ((parent isKindOf: JSTryStatementNode)
				and: [ parent exceptionType == self ]) not ]
]
