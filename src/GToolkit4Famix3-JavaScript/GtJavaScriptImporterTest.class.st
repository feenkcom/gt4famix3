"
This class contains tests

"
Class {
	#name : #GtJavaScriptImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'samples',
		'importer'
	],
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
GtJavaScriptImporterTest >> sample [
	^ ''
		
]

{ #category : #accessing }
GtJavaScriptImporterTest >> samples [
	^ { self sample }
]

{ #category : #running }
GtJavaScriptImporterTest >> setUp [
	| dir |
	dir := FileSystem memory workingDirectory / 'src'.
	dir ensureCreateDirectory.
	self samples
		keysAndValuesDo: [ :i :each | 
			| filename |
			filename := dir / ('sample' , i printString , '.js').
			filename writeStreamDo: [ :stream | stream nextPutAll: each ] ].
	importer := GtJSImporter new.
	importer importDirectory: dir
]
