Extension { #name : #FAMIXBehaviouralEntity }

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXBehaviouralEntity >> lookupVariableWithNames: aCollectionOfStrings [
	| possibleVariable possibleUnit possibleType |
	aCollectionOfStrings size = 1 ifTrue: [ ^ self lookupVariableNamed: aCollectionOfStrings anyOne ].
	possibleVariable := self lookupVariableNamed: aCollectionOfStrings first.
	possibleVariable ifNotNil: [ ^ possibleVariable declaredType lookupVariableWithNames: aCollectionOfStrings allButFirst ].
	possibleUnit := self lookupUnitNamed: aCollectionOfStrings first.
	possibleUnit ifNotNil: [ ^ possibleUnit lookupVariableWithNames: aCollectionOfStrings allButFirst ].
	possibleType := self lookupTypeNamed: aCollectionOfStrings first.
	possibleType ifNotNil: [ ^ possibleType lookupVariableWithNames: aCollectionOfStrings allButFirst ].
	^ nil

]
