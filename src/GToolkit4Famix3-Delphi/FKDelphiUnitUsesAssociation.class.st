Class {
	#name : #FKDelphiUnitUsesAssociation,
	#superclass : #FAMIXAssociation,
	#instVars : [
		'userUnit',
		'usedUnit',
		'signature',
		'isInterface'
	],
	#category : #'GToolkit4Famix3-Delphi-Importer'
}

{ #category : #meta }
FKDelphiUnitUsesAssociation class >> annotation [
	<MSEClass: #UnitUsesAssociation super: #FAMIXAssociation>
	<package: #Delphi>
	^self
]

{ #category : #accessing }
FKDelphiUnitUsesAssociation >> from [
	^ self userUnit
]

{ #category : #accessing }
FKDelphiUnitUsesAssociation >> isInterface [
	^ isInterface
]

{ #category : #accessing }
FKDelphiUnitUsesAssociation >> isInterface: anObject [
	isInterface := anObject
]

{ #category : #accessing }
FKDelphiUnitUsesAssociation >> signature [
	^ signature
]

{ #category : #accessing }
FKDelphiUnitUsesAssociation >> signature: anObject [
	signature := anObject
]

{ #category : #accessing }
FKDelphiUnitUsesAssociation >> to [
	^ self usedUnit
]

{ #category : #accessing }
FKDelphiUnitUsesAssociation >> usedUnit [
	<MSEProperty: #usedUnit type: #FKDelphiScopingEntity opposite: #incomingUsesAssociations>

	^ usedUnit
]

{ #category : #accessing }
FKDelphiUnitUsesAssociation >> usedUnit: aUnit [
	usedUnit := FMMultivalueLink on: self
					update: #incomingUsesAssociations
					from: self usedUnit
					to: aUnit
]

{ #category : #accessing }
FKDelphiUnitUsesAssociation >> userUnit [
	<MSEProperty: #userUnit type: #FKDelphiScopingEntity opposite: #outgoingUsesAssociations>

	^ userUnit
]

{ #category : #accessing }
FKDelphiUnitUsesAssociation >> userUnit: aUnit [
	userUnit := FMMultivalueLink on: self
					update: #outgoingUsesAssociations
					from: self userUnit
					to: aUnit
]
