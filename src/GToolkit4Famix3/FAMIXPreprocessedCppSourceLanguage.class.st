Class {
	#name : #FAMIXPreprocessedCppSourceLanguage,
	#superclass : #FAMIXCppSourceLanguage,
	#instVars : [
		'preprocessor'
	],
	#category : #GToolkit4Famix3
}

{ #category : #'as yet unclassified' }
FAMIXPreprocessedCppSourceLanguage >> gtASTNodeFor: aString at: anInterval [
	| ast preprocessedSource innerNode |
	preprocessedSource := preprocessor copy
		processSource: aString asString
			inInterval: (1 to: aString size)
			isMacro: false;
		preprocessedFile.
	ast := CPPParser parseWithErrors: preprocessedSource sourceString.
	ast
		withAllNodesDo: [ :each | 
			(anInterval first
				= (preprocessedSource startPositionFor: each startPosition)
				and: [ anInterval last
						= (preprocessedSource stopPositionFor: each stopPosition) ])
				ifTrue: [ innerNode := each ] ].
	^ innerNode
]

{ #category : #'as yet unclassified' }
FAMIXPreprocessedCppSourceLanguage >> gtStyler [
	^ (GtSmaCCPreprocessedParserStyler cppStyler: CPPParser)
		preprocessor: preprocessor copy
]

{ #category : #accessing }
FAMIXPreprocessedCppSourceLanguage >> preprocessor: anObject [
	preprocessor := anObject
]
