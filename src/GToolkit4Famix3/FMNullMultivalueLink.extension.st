Extension { #name : #FMNullMultivalueLink }

{ #category : #'*GToolkit4Famix3' }
FMNullMultivalueLink >> asBrItemsProvider [
	^ BrSequenceableCollectionItemsProvider forCollection: self
]
