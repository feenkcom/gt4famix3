Class {
	#name : #VSProject,
	#superclass : #FAMIXNamedEntity,
	#instVars : [
		'folder',
		'compileIncludes'
	],
	#category : #'GToolkit4Famix-VisualStudio'
}

{ #category : #meta }
VSProject class >> annotation [ 
	<MSEClass: #VSProject super: #FAMIXNamedEntity>
	<package: #FAMIX>
]
