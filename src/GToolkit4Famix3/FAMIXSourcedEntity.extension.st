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
	^ self hasSourceAnchor 
		ifFalse: [ aView empty ]
		ifTrue: [ self sourceAnchor gtCompleteSourceFor: aView ]
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
