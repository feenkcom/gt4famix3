Class {
	#name : #GtJSClass,
	#superclass : #FAMIXClass,
	#instVars : [
		'accesses'
	],
	#category : #'GToolkit4Famix3-JavaScript-Model'
}

{ #category : #acccessing }
GtJSClass >> accesses [
	^ accesses
]

{ #category : #initialization }
GtJSClass >> initialize [
	super initialize.
	accesses := FMNullMultivalueLink
		on: self
		opposite: #accessor:
		selector: #accesses
]
