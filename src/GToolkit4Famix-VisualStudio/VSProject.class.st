Class {
	#name : #VSProject,
	#superclass : #FAMIXNamedEntity,
	#instVars : [
		'projectFile',
		'compiledFiles',
		'includedFiles'
	],
	#category : #'GToolkit4Famix-VisualStudio'
}

{ #category : #meta }
VSProject class >> annotation [ 
	<MSEClass: #VSProject super: #FAMIXNamedEntity>
	<package: #FAMIX>
]

{ #category : #accessing }
VSProject >> compiledFiles [
	<MSEProperty: #compiledFiles type: #VSProjectFileCompile opposite: #project> <multivalued> <derived>
	^ compiledFiles
]

{ #category : #accessing }
VSProject >> compiledFiles: anObject [
	compiledFiles := anObject
]

{ #category : #accessing }
VSProject >> includedFiles [
	<MSEProperty: #includedFiles type: #VSProjectFileInclude opposite: #project> <multivalued> <derived>
	^ includedFiles
]

{ #category : #accessing }
VSProject >> includedFiles: anObject [
	includedFiles := anObject
]

{ #category : #initialization }
VSProject >> initialize [
	super initialize.
	compiledFiles := FMNullMultivalueLink on: self opposite: #project: selector: #compiledFiles.
	includedFiles := FMNullMultivalueLink on: self opposite: #project: selector: #includedFiles.
]

{ #category : #accessing }
VSProject >> projectFile [
	^ projectFile
]

{ #category : #accessing }
VSProject >> projectFile: anObject [
	projectFile := anObject
]
