Class {
	#name : #VSProjectFileCompile,
	#superclass : #VSProjectFileReference,
	#category : #'GToolkit4Famix-VisualStudio'
}

{ #category : #meta }
VSProjectFileCompile class >> annotation [
	<MSEClass: #VSProjectFileCompile super: #FAMIXAssociation>
	<package: #FAMIX>
	^self
]

{ #category : #accessing }
VSProjectFileCompile >> file [
	<MSEProperty: #file type: #FAMIXFile opposite: #compiledInProjects>
	
	^ file
]

{ #category : #accessing }
VSProjectFileCompile >> file: aFile [
	file := FMMultivalueLink on: self
					update: #compiledInProjects
					from: self file
					to: aFile
]

{ #category : #accessing }
VSProjectFileCompile >> project [
	<MSEProperty: #project type: #VSProject opposite: #compiledFiles>
	
	^ project
]

{ #category : #accessing }
VSProjectFileCompile >> project: aVSProject [
	project := FMMultivalueLink on: self
					update: #compiledFiles
					from: self file
					to: aVSProject
]
