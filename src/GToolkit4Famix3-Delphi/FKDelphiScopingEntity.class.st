Class {
	#name : #FKDelphiScopingEntity,
	#superclass : #FAMIXNamespace,
	#instVars : [
		'outgoingUsesAssociations',
		'incomingUsesAssociations',
		'scopedVariables'
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
FKDelphiScopingEntity >> clientBehaviours [
	<navigation: 'Client behaviours'>
	^ self functions flatCollectAsSet: [:each | each clientBehaviours]
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
	incomingUsesAssociations := FMNullMultivalueLink on: self opposite: #usedUnit: selector: #incomingUsesAssociations.
	scopedVariables := FMNullMultivalueLink on: self opposite: #parentScope: selector: #scopedVariables.

]

{ #category : #lookup }
FKDelphiScopingEntity >> lookup: aBlock named: aString [
	| lookup |
	^ (aBlock value: self)
		detect: [ :each | each name asLowercase = aString asLowercase ]
		ifNone: [ 
			self outgoingUsesAssociations do: [ :association | 
				lookup := (aBlock value: association usedUnit) 
					detect: [ :each | each name = aString ]
					ifNone: [ nil ].
				lookup ifNotNil: [ ^ lookup ] ].
			nil ]
]

{ #category : #lookup }
FKDelphiScopingEntity >> lookupFunctionNamed: aString [
	^ self 
		lookup: [:unit | unit functions ] 
		named: aString
]

{ #category : #lookup }
FKDelphiScopingEntity >> lookupTypeNamed: aString [
	^ self 
		lookup: [:unit | unit types ] 
		named: aString
]

{ #category : #lookup }
FKDelphiScopingEntity >> lookupUnitNamed: aString [
	self flag: 'this is a hack. make it more explicit'.
	^ self 
		lookup: [:unit | {unit} ] 
		named: aString
]

{ #category : #lookup }
FKDelphiScopingEntity >> lookupVariableNamed: aString [
	^ self 
		lookup: [:unit | unit scopedVariables ] 
		named: aString
]

{ #category : #lookup }
FKDelphiScopingEntity >> lookupVariableWithNames: aCollectionOfStrings [
	| possibleType possibleVariable |
	aCollectionOfStrings size = 1 ifTrue: [ ^ self lookupVariableNamed: aCollectionOfStrings anyOne ].
	possibleVariable := self lookupVariableNamed: aCollectionOfStrings first.
	possibleVariable ifNotNil: [ ^ possibleVariable declaredType lookupVariableWithNames: aCollectionOfStrings allButFirst ].
	possibleType := self lookupTypeNamed: aCollectionOfStrings first.
	possibleType ifNotNil: [ ^ possibleType lookupVariableWithNames: aCollectionOfStrings allButFirst ].
	^ nil
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

{ #category : #ui }
FKDelphiScopingEntity >> mooseFinderFunctionDependenciesIn: composite [
	<moosePresentationOrder: 20>
	composite roassal2
			title: 'Functions dependencies';
			titleIcon: MooseIcons mooseDependencies;
			initializeView: [ RTMondrian new ];
			painting: [ :view |
				view shape label text: #name; color: Color black; fontSize: 20.
				view nodes: self functions.
				view shape line color: (Color gray alpha: 0.5); width: 3. 
				view edges connectToAll: #providerBehaviours.
				view layout horizontalDominanceTree layered verticalGap: 20; horizontalGap: 50 .
				view view elements @ RTSelectable
				 ]
]

{ #category : #ui }
FKDelphiScopingEntity >> mooseFinderWithinUsagesIn: composite [
	<moosePresentationOrder: 20>
	composite roassal2
			title: 'Within usages';
			titleIcon: MooseIcons mooseCluster;
			initializeView: [ RTMondrian new ];
			painting: [ :view |
				(( {self} asSet , self providerUnits , self clientUnits) reject: #isStub) asMooseGroup 
					viewUsesHighlighting: {self} 
					on: view ]
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
FKDelphiScopingEntity >> providerBehaviours [
	<navigation: 'Provider behaviours'>
	^ self functions flatCollectAsSet: [:each | each providerBehaviours]
]

{ #category : #query }
FKDelphiScopingEntity >> providerUnits [
	<MSEProperty: #providerUnits type: #FKDelphiUnit> <derived> <multivalued>
	^ (self outgoingUsesAssociations collectAsSet: [ :each | each usedUnit ]) reject: [ :each | each isNil ]
]

{ #category : #accessing }
FKDelphiScopingEntity >> scopedVariables [
	<MSEProperty: #scopedVariables type: #FKDelphiUnitVariable opposite: #parentScope> <multivalued> <derived>

	^ scopedVariables
]

{ #category : #accessing }
FKDelphiScopingEntity >> scopedVariables: anObject [
	scopedVariables value: anObject
]
