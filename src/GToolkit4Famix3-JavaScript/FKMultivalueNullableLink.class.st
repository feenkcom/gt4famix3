Class {
	#name : #FKMultivalueNullableLink,
	#superclass : #FMMultivalueLink,
	#category : #'GToolkit4Famix3-JavaScript-Dojo'
}

{ #category : #accessing }
FKMultivalueNullableLink >> add: anElement [
	anElement isNil
		ifTrue: [ self unsafeAdd: anElement ]
		ifFalse: [ super add: anElement ].
	^ anElement
]

{ #category : #accessing }
FKMultivalueNullableLink >> remove: anElement ifAbsent: exceptionBlock [
	anElement isNil
		ifTrue: [ values remove: anElement ifAbsent: [ ^ exceptionBlock value ] ]
		ifFalse: [ super remove: anElement ifAbsent: exceptionBlock ].
	^ anElement
]
