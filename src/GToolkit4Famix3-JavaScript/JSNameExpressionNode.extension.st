Extension { #name : #JSNameExpressionNode }

{ #category : #'*GToolkit4Famix3-JavaScript' }
JSNameExpressionNode >> isVariableReference [
	^ (parent isKindOf: JSPropertyAssignmentNode) not
		and: [ ((parent isKindOf: JSFunctionNode) and: [ parent name == self ]) not
				and: [ (parent isKindOf: JSVariableDeclarationNode) not and: [ ((parent isKindOf: JSTryStatementNode) and: [ parent exceptionType == self ]) not ] ] ]
]
