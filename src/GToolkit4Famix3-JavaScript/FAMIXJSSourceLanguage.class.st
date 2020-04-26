Class {
	#name : #FAMIXJSSourceLanguage,
	#superclass : #FAMIXSourceLanguage,
	#instVars : [
		'parserClass'
	],
	#category : #'GToolkit4Famix3-JavaScript-Model'
}

{ #category : #accessing }
FAMIXJSSourceLanguage >> gtASTNodeFor: aString at: anInterval [
	| ast |
	ast := self parserClass parseWithErrors: aString.
	ast
		withAllNodesDo: [ :each | 
			(anInterval first <= each startPosition
				and: [ anInterval last = each stopPosition ])
				ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : #accessing }
FAMIXJSSourceLanguage >> gtStyler [
	^ self parserClass gtStyler
]

{ #category : #accessing }
FAMIXJSSourceLanguage >> parserClass [
	^ parserClass ifNil: [ JSParser ]
]

{ #category : #accessing }
FAMIXJSSourceLanguage >> parserClass: aSmaCCParser [
	parserClass := aSmaCCParser
]
