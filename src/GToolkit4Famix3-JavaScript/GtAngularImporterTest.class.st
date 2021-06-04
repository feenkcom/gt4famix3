"
This class contains tests

"
Class {
	#name : #GtAngularImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'samples',
		'importer'
	],
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
GtAngularImporterTest >> sample [
	^ ''
		
]

{ #category : #accessing }
GtAngularImporterTest >> samples [
	^ #(sample)
]

{ #category : #running }
GtAngularImporterTest >> setUp [
	| root |
	importer := GtAngularImporter new.
	root := FileSystem memory workingDirectory / 'root'.
	root ensureCreateDirectory.
	self samples do: [ :each |
		((root / each), 'js') writeStreamDo: [ :s | s nextPutAll: (self perform: each) ] ].
	importer importDirectory: root
]
