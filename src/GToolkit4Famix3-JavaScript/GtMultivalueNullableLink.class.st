Class {
	#name : #GtMultivalueNullableLink,
	#superclass : #FMMultivalueLink,
	#category : #'GToolkit4Famix3-JavaScript-Model'
}

{ #category : #accessing }
GtMultivalueNullableLink >> add: anElement [
	anElement isNil
		ifTrue: [ self unsafeAdd: anElement ]
		ifFalse: [ super add: anElement ].
	^ anElement
]

{ #category : #accessing }
GtMultivalueNullableLink >> remove: anElement ifAbsent: exceptionBlock [
	anElement isNil
		ifTrue: [ values remove: anElement ifAbsent: [ ^ exceptionBlock value ] ]
		ifFalse: [ super remove: anElement ifAbsent: exceptionBlock ].
	^ anElement
]
