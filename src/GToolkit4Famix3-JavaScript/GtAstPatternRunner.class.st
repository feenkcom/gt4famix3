Class {
	#name : #GtAstPatternRunner,
	#superclass : #Object,
	#instVars : [
		'patterns',
		'block'
	],
	#category : #'GToolkit4Famix3-JavaScript-Dojo'
}

{ #category : #'instance creation' }
GtAstPatternRunner class >> forPatterns: patternAstCollection do: aBlock [
	^ self new
		patterns: patternAstCollection;
		block: aBlock;
		yourself
]

{ #category : #accessing }
GtAstPatternRunner >> block [
	^ block
]

{ #category : #accessing }
GtAstPatternRunner >> block: anObject [
	block := anObject
]

{ #category : #executing }
GtAstPatternRunner >> execute: aNode [
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
GtAstPatternRunner >> patterns [
	^ patterns
]

{ #category : #accessing }
GtAstPatternRunner >> patterns: anObject [
	patterns := anObject
]
