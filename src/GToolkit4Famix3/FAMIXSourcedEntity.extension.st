Extension { #name : #FAMIXSourcedEntity }

{ #category : #'*GToolkit4Famix3' }
FAMIXSourcedEntity >> astStartPosition [
	<MSEProperty: #astStartPosition type: #Number>
	^ self privateState attributeAt: #astStartPosition ifAbsent: [  ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourcedEntity >> astStartPosition: aNumber [
	self privateState attributeAt: #astStartPosition put: aNumber 
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourcedEntity >> astStopPosition [
	<MSEProperty: #astStopPosition type: #Number>
	^ self privateState attributeAt: #astStopPosition ifAbsent: [  ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourcedEntity >> astStopPosition: aNumber [
	self privateState attributeAt: #astStopPosition put: aNumber 
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourcedEntity >> findASTNode [
	^ self sourceLanguage
		ifNotNil: [ :lang | 
			self sourceAnchor
				ifNotNil: [ :anchor | 
					lang
						gtASTNodeFor: anchor completeText
						at: (anchor startPos to: anchor endPos) ] ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourcedEntity >> gtASTNode [
	^ self propertyNamed: #ast ifAbsentPut: [ self findASTNode ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourcedEntity >> gtFamixExpanderView [
	^ self gtSourceFor: GtPhlowView new
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourcedEntity >> gtInspectButtonPosition [
	^ self privateState
		attributeAt: #inspectButtonPosition
		ifAbsent: [ self sourceAnchor ifNotNil: [ :anchor | anchor endPos ] ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourcedEntity >> gtInspectButtonPosition: anInteger [
	^ self privateState attributeAt: #inspectButtonPosition put: anInteger
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourcedEntity >> gtLinksForFile: aFileReference do: aBlock [
	(self propertyNamed: #ast)
		ifNotNil: [ :ast | 
			ast gtHasLinks
				ifTrue: [ ^ ast gtLinksFor: self do: aBlock ] ].
	self sourceAnchor
		ifNotNil: [ :anchor | 
			anchor isFile
				ifTrue: [ anchor fileReference = aFileReference
						ifTrue: [ aBlock value: self value: anchor startPos value: anchor endPos ] ] ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourcedEntity >> gtSourceFor: aView [
	<gtView>
	self hasSourceAnchor ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Source';
		priority: 5;
		object: [ self sourceAnchor ];
		view: #gtCompleteSourceFor:
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourcedEntity >> gtStyler [
	^ self sourceLanguage ifNotNil: [ :lang | lang gtStylerFor: self ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourcedEntity >> spotterPreviewSourceIn: composite [
	<spotterPreview: 0>
	composite text 
		title: [ self mooseName ];
		display: #yourself;
		entity: self sourceText
]
