Extension { #name : #MooseModel }

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
MooseModel >> gtItemsFor: aView [
	^ aView empty
]

{ #category : #'*GToolkit4Famix3' }
MooseModel >> spotter: aStringTitle on: aCandidatesBlock for: aStep [
	aCandidatesBlock value isEmpty ifTrue: [ ^ self ].
	^ aStep listProcessor
		title: aStringTitle;
		candidatesLimit: 5;
		allCandidates: aCandidatesBlock;
		itemName: [ :each | each mooseName ];
"		itemIcon: [ :each | each mooseIcon ];"
		actLogic: [ :each :step |
			step exit.
			GtInspector openOn: each ];
		filter: GTFilterSubstring;
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
