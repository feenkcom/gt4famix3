Class {
	#name : #FKJavaScriptImporter,
	#superclass : #FAMIXNamedEntity,
	#instVars : [
		'functions'
	],
	#category : #'GToolkit4Famix3-JavaScript-Importer'
}

{ #category : #private }
FKJavaScriptImporter >> createFunctionNamed: aString [
	^ FAMIXFunction new name: aString
]

{ #category : #private }
FKJavaScriptImporter >> ensureFunctionNamed: aString [
	^ self functions
		at: aString
		ifAbsentPut: [ self createFunctionNamed: aString ]
]

{ #category : #accessing }
FKJavaScriptImporter >> functions [
	^ functions
]

{ #category : #accessing }
FKJavaScriptImporter >> functions: anObject [
	functions := anObject
]

{ #category : #importing }
FKJavaScriptImporter >> importFiles: aCollectionOfFiles [
	aCollectionOfFiles do: [ :file | self importJSFile: file ]
]

{ #category : #importing }
FKJavaScriptImporter >> importJSFile: aFile [
	aFile readStreamDo: [ :s | self importStream: s ]
]

{ #category : #importing }
FKJavaScriptImporter >> importStream: aStream [
	| ast |
	ast := JSParser parseStream: aStream.
	ast acceptVisitor: (FKJavaScriptFunctionNestingVisitor new importer: self).	
	ast acceptVisitor: (FKJavaScriptFunctionNestingVisitor new importer: self).

]

{ #category : #'initialize-release' }
FKJavaScriptImporter >> initialize [
	functions := Dictionary new
]
