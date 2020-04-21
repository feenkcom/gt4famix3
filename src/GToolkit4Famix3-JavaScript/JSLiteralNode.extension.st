Extension { #name : #JSLiteralNode }

{ #category : #'*GToolkit4Famix3-JavaScript' }
JSLiteralNode >> asPharoString [
	^ self value value pharoFromJSString
]
