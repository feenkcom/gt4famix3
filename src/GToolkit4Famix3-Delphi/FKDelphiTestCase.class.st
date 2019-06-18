"
This offers an simple infrastructure for testing the Delphi importer. Subclasses should either override the unit method to provide a source string, or pasFiles to provide a list of multiple units.
"
Class {
	#name : #FKDelphiTestCase,
	#superclass : #TestCase,
	#instVars : [
		'importer',
		'model',
		'logger'
	],
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #hooks }
FKDelphiTestCase >> dfmFiles [
	^ {}
]

{ #category : #hooks }
FKDelphiTestCase >> dprFiles [
	^ {}
]

{ #category : #hooks }
FKDelphiTestCase >> files [
	^ { #unitPas }
]

{ #category : #hooks }
FKDelphiTestCase >> pasFiles [
	^ { #unit }
]

{ #category : #running }
FKDelphiTestCase >> setUp [
	| rootDirectory pieces fileBaseName fileExtension |
	importer := FKDelphiImporter new.
	rootDirectory := FileSystem memory workingDirectory / 'src'.
	rootDirectory createDirectory.
	self files do: [ :each |
		pieces := each piecesCutWhereCamelCase.
		fileBaseName := ('' join: pieces allButLast).
		fileExtension := pieces last asLowercase.
		(rootDirectory / fileBaseName , fileExtension) writeStreamDo: [ :s | s nextPutAll: (self perform: each) ] ].
	logger := MemoryLogger new.
	logger runDuring: [importer importDirectory: rootDirectory].
	model := importer targetModel
]

{ #category : #hooks }
FKDelphiTestCase >> unit [
	^ ''
]

{ #category : #hooks }
FKDelphiTestCase >> unitPas [
	^ ''
]
