Extension { #name : #FAMIXClass }

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXClass >> lookupUnitNamed: aString [ 
	^ self container lookupUnitNamed: aString
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXClass >> lookupVariableWithNames: aCollectionOfStrings [
	| possibleVariable |
	aCollectionOfStrings size = 1 ifTrue: [ ^ self lookupVariableNamed: aCollectionOfStrings anyOne ].
	possibleVariable := self lookupVariableNamed: aCollectionOfStrings first.
	possibleVariable ifNotNil: [ 
		^ possibleVariable declaredType lookupVariableWithNames: aCollectionOfStrings allButFirst ].
	^ nil
]
