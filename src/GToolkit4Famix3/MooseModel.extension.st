Extension { #name : #MooseModel }

{ #category : #'*GToolkit4Famix3-Python' }
MooseModel >> allDjangoRenderInvocations [
	<navigation: 'All Django render invocations'>
	^ self allInvocations select: [ :i | (i propertyNamed: #djangoRender) = true ]
]

{ #category : #'*GToolkit4Famix3' }
MooseModel >> allGtOpenApiPaths [
	<navigation: 'All OpenApi Paths'>
	^ GtOpenApiPathGroup withAll: (self allWithType: GtOpenApiPath)
]

{ #category : #'*GToolkit4Famix3' }
MooseModel >> fileAnchorFor: aFileReference [
	| encoding |
	aFileReference exists
		ifFalse: [ ^ nil ].
	encoding := [ aFileReference
		binaryReadStreamDo: [ :in | (ZnCharacterEncoder detectEncoding: in upToEnd) identifier ] ]
		on: ZnCharacterEncodingError
		do: [ :ex | ex return: 'utf-8' ].
	^ FAMIXIndexedFileAnchor
		fileName:
			(aFileReference relativeTo: self rootFolder asFileReference)
				pathString
		startPos: 1
		endPos:
			(aFileReference
				readStreamEncoded: encoding
				do: [ :stream | stream contents size ])
		model: self
]

{ #category : #'*GToolkit4Famix3' }
MooseModel >> generateAstPositionsFor: each basedOn: item [
	^ each sourceAnchor isNil
		ifTrue: [ | start stop |
			start := each propertyNamed: #astStartPosition ifAbsent: [  ].
			stop := each propertyNamed: #astStopPosition ifAbsent: [  ].
			(start notNil and: [ stop notNil ])
				ifTrue: [ (item notNil and: [ item sourceAnchor notNil ])
						ifTrue: [ (item sourceAnchor isKindOf: FAMIXIndexedFileAnchor)
								ifTrue: [ each
										fileAnchorPath: item sourceAnchor fileName
										startPos: start
										endPos: stop ].
							(item sourceAnchor isKindOf: FAMIXIndexedFileEntityAnchor)
								ifTrue: [ each
										sourceAnchor:
											(FAMIXIndexedFileEntityAnchor new
												correspondingFile: item sourceAnchor correspondingFile;
												startPos: start;
												endPos: stop;
												model: self;
												yourself) ] ] ] ]
]

{ #category : #'*GToolkit4Famix3' }
MooseModel >> generateFileEntities [
	| files |
	files := Dictionary new.
	self allFiles
		do: [ :each | 
			(each sourceAnchor notNil and: [ each sourceAnchor isFile ])
				ifTrue: [ files at: each sourceAnchor fileReference put: each ] ].
	(self allWithSubTypesOf: FAMIXSourcedEntity)
		do: [ :each | 
			(each sourceAnchor notNil and: [ each sourceAnchor isFile ])
				ifTrue: [ | file fileRef |
					fileRef := each sourceAnchor fileReference.
					file := files at: fileRef ifAbsent: [  ].
					file isNil
						ifTrue: [ file := FAMIXFile new.
							file name: fileRef basename.
							files at: fileRef put: file.
							self add: file.
							(self fileAnchorFor: fileRef)
								ifNotNil: [ :anchor | 
									anchor correspondingFile: file.
									file sourceAnchor: anchor ]
								ifNil: [ file isStub: true ] ].
					(file entities includes: each)
						ifFalse: [ file addEntity: each ].
					each sourceAnchor correspondingFile isNil
						ifTrue: [ each sourceAnchor correspondingFile: file ] ] ]
]

{ #category : #'*GToolkit4Famix3' }
MooseModel >> generateMisssingSourceAnchors [
	(self allWithSubTypesOf: FAMIXAssociation)
		do: [ :each | self generateAstPositionsFor: each basedOn: each from ].
	(self allWithSubTypesOf: FAMIXAnnotationInstance)
		do:
			[ :each | self generateAstPositionsFor: each basedOn: each annotatedEntity ].
	(self allWithSubTypesOf: FAMIXLeafEntity)
		do: [ :each | self generateAstPositionsFor: each basedOn: each belongsTo ]
]

{ #category : #'*GToolkit4Famix3' }
MooseModel >> gtItemsFor: aView [
	^ aView empty
]

{ #category : #'*GToolkit4Famix3' }
MooseModel >> gtRootFolderFor: aView [
	<gtView>
	self rootFolder isNil ifTrue: [ ^ aView empty].
	^ (self rootFolder gtTreeFor: aView) title: 'Root folder'
]

{ #category : #'*GToolkit4Famix3' }
MooseModel >> gtSpotterAnnotationTypesFor: aStep [
	<gtSearch>
	^ self spotter: 'Annotation types' on: [ self allAnnotationTypes ] for: aStep
]

{ #category : #'*GToolkit4Famix3' }
MooseModel >> gtSpotterClassesFor: aStep [
	<gtSearch>
	^ self spotter: 'Classes' on: [ self allClasses ] for: aStep
]

{ #category : #'*GToolkit4Famix3' }
MooseModel >> gtSpotterMethodsFor: aStep [
	<gtSearch>
	^ self spotter: 'Methods' on: [ self allMethods ] for: aStep
]

{ #category : #'*GToolkit4Famix3' }
MooseModel >> spotter: aStringTitle on: aCandidatesBlock for: aSearch [
	aCandidatesBlock value isEmpty ifTrue: [ ^ aSearch empty ].
	^ aSearch list
		title: aStringTitle;
		items: aCandidatesBlock;
		itemsLimit: 5;
		itemName: [ :each | each mooseName ];
"		itemIcon: [ :each | each mooseIcon ];"
		"actLogic: [ :each :step |
			step exit.
			GtInspector openOn: each ];"
		filterBySubstring;
		wantsToDisplayOnEmptyQuery: true
]

{ #category : #'*GToolkit4Famix3' }
MooseModel >> spotterClassesFor: aStep [
	<spotterOrder: 20>
	self spotter: 'All classes' on: [ self allClasses ] for: aStep
]

{ #category : #'*GToolkit4Famix3' }
MooseModel >> spotterMethodsFor: aStep [
	<spotterOrder: 30>
	self spotter: 'All methods' on: [ self allMethods ] for: aStep
]
