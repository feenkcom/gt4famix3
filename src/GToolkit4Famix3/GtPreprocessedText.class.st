Class {
	#name : 'GtPreprocessedText',
	#superclass : 'Object',
	#instVars : [
		'preprocessedSource',
		'text'
	],
	#category : 'GToolkit4Famix3'
}

{ #category : 'converting' }
GtPreprocessedText >> asString [
	^ text asString
]

{ #category : 'accessing' }
GtPreprocessedText >> from: startIndex to: stopIndex [
	^ text
		from: (preprocessedSource startPositionFor: startIndex)
		to: (preprocessedSource stopPositionFor: stopIndex)
]

{ #category : 'accessing' }
GtPreprocessedText >> preprocessedSource: anObject [
	preprocessedSource := anObject
]

{ #category : 'accessing' }
GtPreprocessedText >> size [
	^ text size
]

{ #category : 'accessing' }
GtPreprocessedText >> text: blText [
	text := blText
]
