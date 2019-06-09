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
FKDelphiTestCase >> dprFiles [
	^ {}
]

{ #category : #hooks }
FKDelphiTestCase >> pasFiles [
	^ { #unit }
]

{ #category : #running }
FKDelphiTestCase >> setUp [
	| rootDirectory |
	importer := FKDelphiImporter new.
	rootDirectory := FileSystem memory workingDirectory / 'src'.
	rootDirectory createDirectory.
	self pasFiles do: [ :each | 
		(rootDirectory / each, 'pas') writeStreamDo: [ :s | s nextPutAll: (self perform: each) ] ].
	self dprFiles do: [ :each | 
		(rootDirectory / each, 'dpr') writeStreamDo: [ :s | s nextPutAll: (self perform: each) ] ].
	logger := MemoryLogger new.
	logger runDuring: [importer importDirectory: rootDirectory].
	model := importer targetModel
]

{ #category : #hooks }
FKDelphiTestCase >> unit [
	^ ''
]
