Extension { #name : #FMMultivalueLink }

{ #category : #'*GToolkit4Famix3' }
FMMultivalueLink >> asBrItemsProvider [
	^ BrSequenceableCollectionItemsProvider forCollection: self
]
