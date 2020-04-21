Extension { #name : #String }

{ #category : #'*GToolkit4Famix3-JavaScript' }
String >> pharoFromJSString [
	^ (((self removePrefix: '''') removeSuffix: '''') removePrefix: '"') removeSuffix: '"'
]
