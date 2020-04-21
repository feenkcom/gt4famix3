Class {
	#name : #FKDojoWidget,
	#superclass : #FAMIXNamedEntity,
	#instVars : [
		'template'
	],
	#category : #'GToolkit4Famix3-JavaScript-Dojo'
}

{ #category : #accessing }
FKDojoWidget >> template [
	^ template
]

{ #category : #accessing }
FKDojoWidget >> template: anObject [
	template := anObject
]
