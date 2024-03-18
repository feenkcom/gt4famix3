Class {
	#name : #MooseIconLoader,
	#superclass : #Object,
	#category : #GToolkit4Famix3
}

{ #category : #'class initialization' }
MooseIconLoader class >> initialize [
	(MooseIcons class gtMethodsInClass & #icons gtReferences
		& #at:ifAbsentPut: gtReferences) contents
		do: [ :each | 
			Smalltalk ui icons icons
				at: each selector
				ifAbsentPut: [ MooseIcons perform: each selector ] ]
]
