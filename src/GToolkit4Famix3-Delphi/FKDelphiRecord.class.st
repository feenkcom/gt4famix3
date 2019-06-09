Class {
	#name : #FKDelphiRecord,
	#superclass : #FAMIXType,
	#category : #'GToolkit4Famix3-Delphi-Importer'
}

{ #category : #meta }
FKDelphiRecord class >> annotation [
	<MSEClass: #Record super: #FAMIXType>
	<package: #Delphi>
	^self
]

{ #category : #'*FKDelphi' }
FKDelphiRecord >> lookupVariableWithNames: aCollectionOfStrings [
	| possibleVariable |
	aCollectionOfStrings size = 1 ifTrue: [ ^ self lookupVariableNamed: aCollectionOfStrings anyOne ].
	possibleVariable := self lookupVariableNamed: aCollectionOfStrings first.
	possibleVariable ifNotNil: [ ^ possibleVariable declaredType lookupVariableWithNames: aCollectionOfStrings allButFirst ].
	^ nil
]
