Extension { #name : #JSVariableDeclarationNode }

{ #category : #'*GToolkit4Famix3-JavaScript' }
JSVariableDeclarationNode >> lhs [
	^ self variable
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
JSVariableDeclarationNode >> rhs [
	^ self value
]
