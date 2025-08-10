Class {
	#name : #GtPythonImporterExamples,
	#superclass : #Object,
	#category : #GToolkit4Famix3
}

{ #category : #'as yet unclassified' }
GtPythonImporterExamples >> multipleFilesImport [
	<gtExample>
	| fs dir a b importer |
	fs := FileSystem memory.
	dir := fs / 'pkg'. dir ensureCreateDirectory.
	a := dir / 'a.py'.
	a writeStreamDo: [ :s | s nextPutAll: 'class A:'; cr; nextPutAll: '    pass'; cr ].
	b := dir / 'b.py'.
	b writeStreamDo: [ :s | s nextPutAll: 'def util(y):'; cr; nextPutAll: '    return y*y'; cr ].
	importer := GtPythonImporter new.
	importer importDirectory: dir.
	importer finishImport.
	self assert: ((importer classes at: 'A' ifAbsent: [ nil ]) notNil).
	^ importer
]

{ #category : #'as yet unclassified' }
GtPythonImporterExamples >> simpleImport [
	<gtExample>
	| fs dir file importer |
	fs := FileSystem memory.
	dir := fs / 'pkg'.
	dir ensureCreateDirectory.
	file := dir / 'foo.py'.
	file writeStreamDo: [ :s |
		s nextPutAll: 'class C:'; cr.
		s nextPutAll: '    def m(self):'; cr.
		s nextPutAll: '        return 1'; cr.
		s nextPutAll: 'def f(x):'; cr; nextPutAll: '    return x'; cr ].
	importer := GtPythonImporter new.
	importer importDirectory: dir.
	importer finishImport.
	self assert: ((importer classes at: 'C' ifAbsent: [ nil ]) notNil).
	^ importer
]
