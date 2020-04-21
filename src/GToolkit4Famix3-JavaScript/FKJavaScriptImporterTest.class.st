Class {
	#name : #FKJavaScriptImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'samples',
		'importer'
	],
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
FKJavaScriptImporterTest >> sample [
	^ ''
		
]

{ #category : #accessing }
FKJavaScriptImporterTest >> samples [
	^ { self sample }
]

{ #category : #running }
FKJavaScriptImporterTest >> setUp [
	importer := FKJavaScriptImporter new.
	samples := self samples.
	samples do: [ :each | importer importStream: each readStream ]
]
