Extension { #name : #JSNameExpressionNode }

{ #category : #'*GToolkit4Famix3-JavaScript' }
JSNameExpressionNode >> isVariableReference [
	(parent isKindOf: JSPropertyAssignmentNode)
		ifTrue: [ ^ false ].
	(((parent isKindOf: JSFunctionNode)
		or: [ (parent isKindOf: JSMethodDefinitionNode)
				or: [ parent isKindOf: JSClassExpressionNode ] ])
		and: [ parent name == self ])
		ifTrue: [ ^ false ].
	^ (parent isKindOf: JSVariableDeclarationNode) not
		and: [ ((parent isKindOf: JSTryStatementNode)
				and: [ parent exceptionType == self ]) not ]
]
