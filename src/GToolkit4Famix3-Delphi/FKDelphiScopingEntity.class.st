Class {
	#name : #FKDelphiScopingEntity,
	#superclass : #FAMIXNamespace,
	#instVars : [
		'outgoingUsesAssociations',
		'incomingUsesAssociations'
	],
	#category : #'GToolkit4Famix3-Delphi-Importer'
}

{ #category : #meta }
FKDelphiScopingEntity class >> annotation [
	<MSEClass: #ScopingEntity super: #FAMIXNamespace>
	<package: #Delphi>
	^self
]

{ #category : #query }
FKDelphiScopingEntity >> ast [
	^ DelphiParser parse: self sourceText
]

{ #category : #query }
FKDelphiScopingEntity >> clientUnits [
	<MSEProperty: #clientUnits type: #FKDelphiScopingEntity> <derived> <multivalued>
	^ (self incomingUsesAssociations collectAsSet: [ :each | each userUnit ]) reject: [ :each | each isNil ]
]

{ #category : #accessing }
FKDelphiScopingEntity >> incomingUsesAssociations [
	<MSEProperty: #incomingUsesAssociations type: #FKDelphiUnitUsesAssociation opposite: #usedUnit> <multivalued> <derived>

	^ incomingUsesAssociations
]

{ #category : #accessing }
FKDelphiScopingEntity >> incomingUsesAssociations: anObject [
	incomingUsesAssociations value: anObject
]

{ #category : #initialize }
FKDelphiScopingEntity >> initialize [
	super initialize.
	outgoingUsesAssociations := FMNullMultivalueLink on: self opposite: #userUnit: selector: #outgoingUsesAssociations.
	incomingUsesAssociations := FMNullMultivalueLink on: self opposite: #usedUnit: selector: #incomingUsesAssociations

]

{ #category : #query }
FKDelphiScopingEntity >> lookup: aBlock named: aString [
	| lookup |
	^ (aBlock value: self)
		detect: [ :each | each name = aString ]
		ifNone: [ 
			self outgoingUsesAssociations do: [ :association | 
				lookup := (aBlock value: association usedUnit) 
					detect: [ :each | each name = aString ]
					ifNone: [ nil ].
				lookup ifNotNil: [ ^ lookup ] ].
			nil ]
]

{ #category : #query }
FKDelphiScopingEntity >> lookupFunctionNamed: aString [
	^ self 
		lookup: [:unit | unit functions ] 
		named: aString
]

{ #category : #query }
FKDelphiScopingEntity >> lookupTypeNamed: aString [
	^ self 
		lookup: [:unit | unit types ] 
		named: aString
]

{ #category : #ui }
FKDelphiScopingEntity >> mooseFinderASTIn: composite [
	<moosePresentationOrder: 20>
	composite tree
			title: 'AST';
			titleIcon: MooseIcons mooseTree;
			display: [ self ast ];
			children: [ :each | each children ]
]

{ #category : #accessing }
FKDelphiScopingEntity >> outgoingUsesAssociations [
	<MSEProperty: #outgoingUsesAssociations type: #FKDelphiUnitUsesAssociation opposite: #userUnit> <multivalued> <derived>

	^ outgoingUsesAssociations
]

{ #category : #accessing }
FKDelphiScopingEntity >> outgoingUsesAssociations: anObject [
	outgoingUsesAssociations value: anObject
]

{ #category : #query }
FKDelphiScopingEntity >> providerUnits [
	<MSEProperty: #providerUnits type: #FKDelphiUnit> <derived> <multivalued>
	^ (self outgoingUsesAssociations collectAsSet: [ :each | each usedUnit ]) reject: [ :each | each isNil ]
]
