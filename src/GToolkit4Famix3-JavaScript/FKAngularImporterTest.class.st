Class {
	#name : #FKAngularImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'samples',
		'importer'
	],
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
FKAngularImporterTest >> sample [
	^ ''
		
]

{ #category : #accessing }
FKAngularImporterTest >> samples [
	^ #(sample)
]

{ #category : #running }
FKAngularImporterTest >> setUp [
	| root |
	importer := FKAngularImporter new.
	root := FileSystem memory workingDirectory / 'root'.
	root ensureCreateDirectory.
	self samples do: [ :each |
		((root / each), 'js') writeStreamDo: [ :s | s nextPutAll: (self perform: each) ] ].
	importer importDirectory: root
]
