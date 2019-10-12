Class {
	#name : #VSProjectFileReference,
	#superclass : #FAMIXAssociation,
	#instVars : [
		'file',
		'project'
	],
	#category : #'GToolkit4Famix-VisualStudio'
}

{ #category : #accessing }
VSProjectFileReference >> file [
	^ self subclassResponsibility
]

{ #category : #accessing }
VSProjectFileReference >> from [
	^ self project
]

{ #category : #accessing }
VSProjectFileReference >> project [
	^ self subclassResponsibility
]

{ #category : #accessing }
VSProjectFileReference >> to [
	^ self file
]
