Extension { #name : #FKDelphiRecord }

{ #category : #'*FKDelphi' }
FKDelphiRecord >> lookupVariableWithNames: aCollectionOfStrings [
	| possibleVariable |
	aCollectionOfStrings size = 1 ifTrue: [ ^ self lookupVariableNamed: aCollectionOfStrings anyOne ].
	possibleVariable := self lookupVariableNamed: aCollectionOfStrings first.
	possibleVariable ifNotNil: [ ^ possibleVariable declaredType lookupVariableWithNames: aCollectionOfStrings allButFirst ].
	^ nil
]
