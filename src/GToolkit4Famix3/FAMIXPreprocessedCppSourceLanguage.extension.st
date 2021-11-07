Extension { #name : #FAMIXPreprocessedCppSourceLanguage }

{ #category : #'*GToolkit4Famix3' }
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

{ #category : #'*GToolkit4Famix3' }
FAMIXPreprocessedCppSourceLanguage >> gtStyler [
	^ (GtSmaCCPreprocessedParserStyler cppStyler: CPPParser)
		preprocessor: preprocessor copy
]
