Class {
	#name : #GtSmaCCPreprocessedParserStyler,
	#superclass : #GtSmaCCParserStyler,
	#instVars : [
		'preprocessedSource',
		'preprocessor'
	],
	#category : #GToolkit4Famix3
}

{ #category : #private }
GtSmaCCPreprocessedParserStyler >> ast [
	preprocessedSource := preprocessor copy
		processSource: text asString
			inInterval: (1 to: text size)
			isMacro: false;
		preprocessedFile.
	^ parserClass
		parseWithErrors: preprocessedSource sourceString
		startingAt: self startingState
]

{ #category : #accessing }
GtSmaCCPreprocessedParserStyler >> preprocessor: anObject [
	preprocessor := anObject
]

{ #category : #private }
GtSmaCCPreprocessedParserStyler >> privateStyle: aText [
	[ | ast |
	text := GtPreprocessedText new text: aText.
	ast := self ast.
	text preprocessedSource: preprocessedSource.
	ast
		withAllNodesDo: [ :node | self styleNode: node ]
		andTokensDo: [ :token | self styleToken: token ]
		includesErrors: true ]
		on: Error
		do: [ :ex | ex return ].
	^ aText
]
