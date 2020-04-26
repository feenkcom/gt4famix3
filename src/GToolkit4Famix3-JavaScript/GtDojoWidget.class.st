Class {
	#name : #GtDojoWidget,
	#superclass : #FAMIXNamedEntity,
	#instVars : [
		'template'
	],
	#category : #'GToolkit4Famix3-JavaScript-Dojo'
}

{ #category : #accessing }
GtDojoWidget >> template [
	^ template
]

{ #category : #accessing }
GtDojoWidget >> template: anObject [
	template := anObject
]
