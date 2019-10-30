Class {
	#name : #VSProjectFileInclude,
	#superclass : #VSProjectFileReference,
	#category : #'GToolkit4Famix3-VisualStudio'
}

{ #category : #meta }
VSProjectFileInclude class >> annotation [
	<MSEClass: #VSProjectFileInclude super: #FAMIXAssociation>
	<package: #FAMIX>
	^self
]

{ #category : #accessing }
VSProjectFileInclude >> file [
	<MSEProperty: #file type: #FAMIXFile opposite: #includedInProjects>

	^ file
]

{ #category : #accessing }
VSProjectFileInclude >> file: aFile [
	file := FMMultivalueLink on: self
					update: #includedInProjects
					from: self file
					to: aFile
]

{ #category : #accessing }
VSProjectFileInclude >> project [
	<MSEProperty: #project type: #VSProject opposite: #includedFiles>
	
	^ project
]

{ #category : #accessing }
VSProjectFileInclude >> project: aVSProject [
	project := FMMultivalueLink on: self
					update: #includedFiles
					from: self file
					to: aVSProject
]
