Class {
	#name : #GtDjangoImporterExamples,
	#superclass : #Object,
	#category : #'GToolkit4Famix3-Python'
}

{ #category : #'llm-generated' }
GtDjangoImporterExamples >> exampleNewImporter [
	<gtExample>
	| importer |
	importer := GtDjangoImporter new.
	self assert: importer notNil.
	self assert: importer urlPatterns isCollection.
	self assert: importer urlPatterns isEmpty.
	^ importer
]

{ #category : #'llm-generated' }
GtDjangoImporterExamples >> exampleWithSampleUrlPatterns [
	<gtExample>
	| importer fakePatterns |
	importer := GtDjangoImporter new.
	fakePatterns := { 'path("admin/", admin.site.urls)'. 'path("", HomeView)' }.
	importer instVarNamed: #urlPatterns put: fakePatterns.
	self assert: importer urlPatterns size = 2.
	self assert: (importer urlPatterns includes: 'path("admin/", admin.site.urls)').
	^ importer
]
