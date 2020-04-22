Class {
	#name : #GtJavaScriptImporter,
	#superclass : #FAMIXNamedEntity,
	#instVars : [
		'functions'
	],
	#category : #'GToolkit4Famix3-JavaScript-Importer'
}

{ #category : #private }
GtJavaScriptImporter >> createFunctionNamed: aString [
	^ FAMIXFunction new name: aString
]

{ #category : #private }
GtJavaScriptImporter >> ensureFunctionNamed: aString [
	^ self functions
		at: aString
		ifAbsentPut: [ self createFunctionNamed: aString ]
]

{ #category : #accessing }
GtJavaScriptImporter >> functions [
	^ functions
]

{ #category : #accessing }
GtJavaScriptImporter >> functions: anObject [
	functions := anObject
]

{ #category : #importing }
GtJavaScriptImporter >> importFiles: aCollectionOfFiles [
	aCollectionOfFiles do: [ :file | self importJSFile: file ]
]

{ #category : #importing }
GtJavaScriptImporter >> importJSFile: aFile [
	aFile readStreamDo: [ :s | self importStream: s ]
]

{ #category : #importing }
GtJavaScriptImporter >> importStream: aStream [
	| ast |
	ast := JSParser parseStream: aStream.
	ast acceptVisitor: (GtJavaScriptFunctionNestingVisitor new importer: self).	
	ast acceptVisitor: (GtJavaScriptFunctionNestingVisitor new importer: self).

]

{ #category : #'initialize-release' }
GtJavaScriptImporter >> initialize [
	functions := Dictionary new
]
