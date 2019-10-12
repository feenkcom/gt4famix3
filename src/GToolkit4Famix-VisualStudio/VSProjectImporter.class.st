Class {
	#name : #VSProjectImporter,
	#superclass : #Object,
	#instVars : [
		'directories',
		'files',
		'folders',
		'projects',
		'compilations',
		'includes'
	],
	#category : #'GToolkit4Famix-VisualStudio'
}

{ #category : #importing }
VSProjectImporter >> ensureFamixFileFromFile: targetFile [
	^ files 
		at: targetFile canonicalize fullName
		ifAbsentPut: [ 
			FAMIXFile new 
				name: targetFile basename;
				isStub: true;
				parentFolder: (self ensureFamixFolderFromDirectory: targetFile parent) ]
]

{ #category : #importing }
VSProjectImporter >> ensureFamixFolderFromDirectory: aDirectory [
	^ folders 
		at: aDirectory canonicalize fullName
		ifAbsentPut: [ 
			FAMIXFolder new 
				name: aDirectory basename;
				isStub: true";
				parent: (self ensureFamixFolderFromDirectory: aDirectory parent)" ]
]

{ #category : #importing }
VSProjectImporter >> importDirectory: aDirectory in: aFamixFolder [
	| newFolder |
	newFolder := self ensureFamixFolderFromDirectory: aDirectory.
	newFolder isStub: false.
	aDirectory directories do: [ :aSubdirectory |
		self importDirectory: aSubdirectory in: newFolder ].
	aDirectory files do: [ :aFile |
		self importFile: aFile in: newFolder ].
]

{ #category : #importing }
VSProjectImporter >> importFile: aFile in: aFamixFolder [
	| famixFile |
	famixFile := self ensureFamixFileFromFile: aFile.
	famixFile isStub: false.
	aFile extension = 'vcxproj' ifTrue: [ 
		self importVisualStudioProject: aFile ]
]

{ #category : #importing }
VSProjectImporter >> importFromDirectory: aDirectory [
	| rootFolder |
	self assert: [ aDirectory exists ].
	self assert: [ aDirectory isDirectory ].
	rootFolder := FAMIXFolder new name: '__ROOT__'.
	folders at: '__ROOT__' put: rootFolder.
	self importDirectory: aDirectory in: rootFolder .
]

{ #category : #importing }
VSProjectImporter >> importVisualStudioProject: aFile [
	| xml vsProject |
	xml := XMLDOMParser parse: aFile.
	vsProject := VSProject new
		projectFile: aFile;
		name: aFile basenameWithoutExtension.
	projects add: vsProject.
	xml // #ClCompile do: [ :compileElement | 
		(compileElement includesAttribute: #Include)
			ifTrue: [ 
				| rawStringPath targetFile targetFamixFile fileCompile |
				rawStringPath := compileElement attributeAt: #Include.
				targetFile := aFile resolveString: (rawStringPath copyReplaceAll: '\' with: FileSystem disk delimiter asString).
				targetFamixFile := self ensureFamixFileFromFile: targetFile.
				fileCompile := VSProjectFileCompile new 
					project: vsProject;
					file: targetFamixFile.
				compilations add: fileCompile ] ].
	xml // #ClInclude do: [ :includeElement | 
		(includeElement includesAttribute: #Include)
			ifTrue: [ 
				| rawStringPath targetFile targetFamixFile fileInclude |
				rawStringPath := includeElement attributeAt: #Include.
				targetFile := aFile resolveString: (rawStringPath copyReplaceAll: '\' with: FileSystem disk delimiter asString).
				targetFamixFile := self ensureFamixFileFromFile: targetFile.
				fileInclude := VSProjectFileInclude new 
					project: vsProject;
					file: targetFamixFile.
				includes add: fileInclude ] ]
]

{ #category : #importing }
VSProjectImporter >> initialize [
	super initialize.
	folders := Dictionary new.
	files := Dictionary new.
	compilations := OrderedCollection new.
	includes := OrderedCollection new.
	projects := OrderedCollection new
]
