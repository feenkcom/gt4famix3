Extension { #name : #FAMIXSourcedEntity }

{ #category : #'*GToolkit4Famix3' }
FAMIXSourcedEntity >> gtSourceFor: aView [
	<gtView>
	^ self hasSourceAnchor 
		ifFalse: [ aView empty ]
		ifTrue: [ self sourceAnchor gtCompleteSourceFor: aView ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourcedEntity >> gtStyler [
	^ self sourceLanguage ifNotNil: [ :lang | lang gtStyler ]
]
