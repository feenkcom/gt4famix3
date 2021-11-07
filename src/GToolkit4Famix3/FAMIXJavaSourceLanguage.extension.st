Extension { #name : #FAMIXJavaSourceLanguage }

{ #category : #'*GToolkit4Famix3' }
FAMIXJavaSourceLanguage >> gtASTNodeFor: aString at: anInterval [
	| ast |
	ast := JavaParser parseWithErrors: aString.
	ast
		withAllNodesDo: [ :each | 
			(anInterval first <= each startPosition
				and: [ anInterval last = each stopPosition ])
				ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : #'*GToolkit4Famix3' }
FAMIXJavaSourceLanguage >> gtStyler [
	^ JavaParser gtStyler
]
