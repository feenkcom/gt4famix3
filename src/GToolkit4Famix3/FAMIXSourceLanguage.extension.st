Extension { #name : #FAMIXSourceLanguage }

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceLanguage >> gtASTNodeFor: aString at: anInterval [
	^ self gtParserClass
		ifNotNil: [ :class | (class parseWithErrors: aString) nodeForInterval: anInterval ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceLanguage >> gtParserClass [
	^ nil
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceLanguage >> gtStyler [
	^ self gtParserClass ifNotNil: [ :class | class gtStyler ]
]
