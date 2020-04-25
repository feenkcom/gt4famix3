Extension { #name : #JSExpressionNode }

{ #category : #'*GToolkit4Famix3-JavaScript' }
JSExpressionNode >> isAssignedTo [
	^ (parent isKindOf: JSAssignmentExpressionNode) and: [ parent lhs == self ]
]
