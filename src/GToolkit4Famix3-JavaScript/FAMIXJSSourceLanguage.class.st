Class {
	#name : #FAMIXJSSourceLanguage,
	#superclass : #FAMIXSourceLanguage,
	#category : #'GToolkit4Famix3-JavaScript-Model'
}

{ #category : #accessing }
FAMIXJSSourceLanguage >> gtASTNodeFor: aString at: anInterval [
	| ast |
	ast := JSParser parseWithErrors: aString.
	ast
		withAllNodesDo: [ :each | 
			(anInterval first <= each startPosition
				and: [ anInterval last = each stopPosition ])
				ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : #accessing }
FAMIXJSSourceLanguage >> gtStyler [
	^ JSParser gtStyler
]
