Class {
	#name : #GtImporterExamples,
	#superclass : #Object,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #samples }
GtImporterExamples >> exampleProject [
	<gtExample>
	<return: #FileReference>
	| dir |
	dir := FileSystem memory workingDirectory / 'project' / 'src'.
	dir ensureCreateDirectory.
	self projectFiles
		do: [ :each | 
			| filename segments |
			segments := each first asFileReference pathSegments.
			filename := dir.
			1 to: segments size - 1 do: [ :i | filename := filename / (segments at: i) ].
			filename ensureCreateDirectory.
			filename := filename / segments last.
			filename writeStreamDo: [ :stream | stream nextPutAll: each last ] ].
	^ dir
]

{ #category : #files }
GtImporterExamples >> projectFiles [
	^ #()
]
