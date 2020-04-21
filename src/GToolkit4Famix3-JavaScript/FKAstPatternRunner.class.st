Class {
	#name : #FKAstPatternRunner,
	#superclass : #Object,
	#instVars : [
		'patterns',
		'block'
	],
	#category : #'GToolkit4Famix3-JavaScript-Dojo'
}

{ #category : #'instance creation' }
FKAstPatternRunner class >> forPatterns: patternAstCollection do: aBlock [
	^ self new
		patterns: patternAstCollection;
		block: aBlock;
		yourself
]

{ #category : #accessing }
FKAstPatternRunner >> block [
	^ block
]

{ #category : #accessing }
FKAstPatternRunner >> block: anObject [
	block := anObject
]

{ #category : #executing }
FKAstPatternRunner >> execute: aNode [
	aNode isNil
		ifTrue: [ ^ false ].
	patterns
		do: [ :each | 
			| context |
			context := Dictionary new.
			(each match: aNode inContext: context)
				ifTrue: [ block cull: aNode cull: (context associations collect: [ :assoc | assoc key name -> assoc value ]) asDictionary.
					^ true ] ].
	^ false
]

{ #category : #accessing }
FKAstPatternRunner >> patterns [
	^ patterns
]

{ #category : #accessing }
FKAstPatternRunner >> patterns: anObject [
	patterns := anObject
]
