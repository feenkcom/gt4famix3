Class {
	#name : #VSProjectImporter,
	#superclass : #Object,
	#instVars : [
		'files',
		'folders',
		'projects',
		'compilations',
		'includes'
	],
	#category : #'GToolkit4Famix3-VisualStudio'
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
				isStub: true;
				parentFolder: (self ensureFamixFolderFromDirectory: aDirectory parent) ]
]

{ #category : #accessing }
VSProjectImporter >> files [
	^ files
]

{ #category : #accessing }
VSProjectImporter >> folders [
	^ folders
]

{ #category : #accessing }
VSProjectImporter >> gtIncludeTreeFor: aView [
	<gtView>
	^ aView mondrian 
		title: 'Include tree';
		painting: [ :m |
m nodes 
	stencil: [ :folder |
		(self projects anySatisfy: [ :po | po projectFile parentFolder = folder]) 
			ifTrue: [ BrLabel new aptitude: BrGlamorousLabelAptitude; text: folder name]
			ifFalse: [ BlElement new geometry: BlEllipseGeometry new; border: (BlBorder paint: Color black width: 2); size: 10@10 ]
		];
	with: self folders values.
m edges 
	fromRightCenter;
	toLeftCenter;
	connectFrom: #parentFolder.
m edges
	stencil: [ 
		BlParabollaArcElement new 
						zIndex: 0;
						curvatureFraction: 0.3;
						border: (BlBorder paint: (Color orange alpha: 0.4) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color orange alpha: 0.4); width: 2; build))
		];
	passive;
	connect: self projects from: [:project | project projectFile parentFolder ] toAll: [ :project | project includedFiles collect: [: include | include file parentFolder  ]].
m layout horizontalTree ].		
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
	rootFolder := FAMIXFolder new name: aDirectory basename.
	folders at: aDirectory canonicalize fullName put: rootFolder.
	self importDirectory: aDirectory in: rootFolder .
]

{ #category : #importing }
VSProjectImporter >> importVisualStudioProject: aFile [
	| xml vsProject |
	xml := XMLDOMParser parse: aFile.
	vsProject := VSProject new
		projectFile: (self ensureFamixFileFromFile: aFile);
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

{ #category : #accessing }
VSProjectImporter >> projects [
	^ projects
]
