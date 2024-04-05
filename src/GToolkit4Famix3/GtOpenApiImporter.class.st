Class {
	#name : #GtOpenApiImporter,
	#superclass : #Object,
	#instVars : [
		'model',
		'baseDirectory',
		'folders',
		'files'
	],
	#category : #'GToolkit4Famix3-OpenApi'
}

{ #category : #accessing }
GtOpenApiImporter >> baseDirectory [
	^ baseDirectory
]

{ #category : #accessing }
GtOpenApiImporter >> baseDirectory: anObject [
	baseDirectory := anObject
]

{ #category : #accessing }
GtOpenApiImporter >> ensureFileFrom: aFileReference [
	files ifNil: [ files := Dictionary new ].
	^ files
		at: aFileReference pathString
		ifAbsentPut: [ | file anchor |
			file := FAMIXFile new.
			file name: aFileReference basename.
			anchor := FAMIXIndexedFileEntityAnchor
					file: file
					startPos: 1
					endPos: aFileReference contents size
					model: model.
			file sourceAnchor: anchor.
			(self ensureFolderNamed: aFileReference parent)
				ifNotNil: [ :folder | folder addChildFileSystemEntity: file ].
			model add: file.
			file ]
]

{ #category : #accessing }
GtOpenApiImporter >> ensureFolderNamed: aDirectory [
	folders
		ifNil: [ | allFolders |
			allFolders := model allWithType: FAMIXFolder.
			folders := Dictionary new.
			allFolders
				do: [ :each | folders at: each fileReference pathString put: each ] ].
	^ folders
		at: aDirectory pathString
		ifAbsentPut: [ | folder |
			folder := FAMIXFolder new.
			(aDirectory = baseDirectory or: [ aDirectory = aDirectory parent ])
				ifTrue: [ folder name: '.' ]
				ifFalse: [ folder name: aDirectory basename.
					(self ensureFolderNamed: aDirectory parent)
						ifNotNil: [ :outer | outer addChildFileSystemEntity: folder ] ].
			model add: folder.
			folder ]
]

{ #category : #importing }
GtOpenApiImporter >> importJson: aString fromFile: aFileReference andLanguage: sourceLanguage findNode: aBlock [
	| openapi parentPaths |
	openapi := [ GtOpenApi fromJsonString: aString ] on: Error do: [ :ex | ^ self ].
	parentPaths := openapi basePath
			ifNil: [ openapi servers notEmpty
					ifTrue: [ openapi servers collect: [ :each | each url ifNil: [ '' ] ] ]
					ifFalse: [ #('') ] ]
			ifNotNil: [ {openapi basePath} ].
	openapi paths
		do: [ :each | 
			| modelPath file |
			modelPath := GtOpenApiPath new
					mooseModel: model;
					basePaths: parentPaths;
					pathItem: each;
					yourself.
			file := self ensureFileFrom: aFileReference.
			file addEntity: modelPath.
			(aBlock cull: each endPoint cull: modelPath method)
				ifNotNil: [ :ast | 
					modelPath propertyNamed: #ast put: ast.
					modelPath
						sourceAnchor: (FAMIXIndexedFileEntityAnchor
								file: file
								startPos: ast startPosition
								endPos: ast stopPosition
								model: model) ].
			modelPath privateState
				attributeAt: #declaredSourceLanguage
				put: sourceLanguage ]
]

{ #category : #importing }
GtOpenApiImporter >> importYamlIn: aDirectory [
	| lang ast paths |
	lang := FAMIXYAMLSourceLanguage new.
	self baseDirectory: aDirectory asFileReference.
	(YAMLParser sourceFilesIn: aDirectory)
		do: [ :each | 
			([ | obj |
			ast := YAMLParser parseFile: each.
			obj := ast createObject.
			((obj includesKey: 'swagger') or: [ obj includesKey: 'openapi' ])
				ifTrue: [ obj ] ] on: Error do: [ :ex | ex return: nil ])
				ifNotNil: [ :dict | 
					paths := (ast /@ 'documents' /@ 'mappings'
							select: [ :node | node key source = 'paths' ])
							flatCollect: [ :node | node value mappings ].
					self
						importJson: (GtJson forJsonObject: dict) asJsonString
						fromFile: each
						andLanguage: lang
						findNode: [ :path :type | 
							paths
								detect: [ :node | 
									| obj |
									obj := node createObject.
									obj key = path and: [ obj value includesKey: type ] ]
								ifNone: [  ] ] ] ]
]

{ #category : #importing }
GtOpenApiImporter >> matchPathsToImplementers: aCollection [
	| implementers |
	implementers := Dictionary new.
	aCollection
		do: [ :each | 
			each
				fullPathsDo: [ :url :type | 
					(implementers
						at: {self normalizeUrl: url.
								type}
						ifAbsentPut: [ OrderedCollection new ]) add: each ] ].
	(model allWithType: GtOpenApiPath)
		do: [ :each | 
			each implementers
				addAll: (each fullPaths
						flatCollect: [ :url | 
							implementers
								at: {self normalizeUrl: url.
										each method}
								ifAbsent: [ #() ] ]) ]
]

{ #category : #accessing }
GtOpenApiImporter >> model [
	^ model
]

{ #category : #accessing }
GtOpenApiImporter >> model: anObject [
	model := anObject
]

{ #category : #importing }
GtOpenApiImporter >> normalizeUrl: url [
	| inStream |
	inStream := url readStream.
	^ String
		streamContents: [ :stream | 
			(url includesSubstring: '://')
				ifTrue: [ inStream
						upToAll: '://';
						upTo: $/;
						position: inStream position - 1 ].
			[ inStream atEnd ]
				whileFalse: [ | char |
					char := inStream next.
					char = ${
						ifTrue: [ stream << '{}'.
							inStream upTo: $} ]
						ifFalse: [ stream nextPut: char ] ] ]
]
