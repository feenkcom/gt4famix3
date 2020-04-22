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
	importer := GtJavaScriptImporter new.
	samples := self samples.
	samples do: [ :each | importer importStream: each readStream ]
]
