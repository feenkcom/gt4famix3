Class {
	#name : #FKDelphiScopingEntityGroup,
	#superclass : #FAMIXNamespaceGroup,
	#category : #'GToolkit4Famix3-Delphi-Importer'
}

{ #category : #meta }
FKDelphiScopingEntityGroup class >> annotation [
	<MSEClass: #ScopingEntityGroup super: #FAMIXNamespaceGroup>
	<package: #Delphi>
	^self
]

{ #category : #accessing }
FKDelphiScopingEntityGroup >> allFiles [
	| files |
	files := OrderedCollection new.
	self do: [ :scopingEntity | 
		scopingEntity sourceAnchor notNil ifTrue: [ 
			files add: scopingEntity sourceAnchor fileReference ] ].
	^ files
]

{ #category : #ui }
FKDelphiScopingEntityGroup >> mooseFinderUsesIn: composite [
	<moosePresentationOrder: 40>
	composite roassal2
		title: 'Uses';
		titleIcon: MooseIcons mooseCluster;
		initializeView: [ RTMondrian new ];
		painting: [ :view | self viewUsesOn: view ]
]

{ #category : #ui }
FKDelphiScopingEntityGroup >> viewUsesHighlighting: aCollection on: view [
	view shape label 
		text: [:each | each name copyReplaceAll: '_' with: ('_', String cr)];
		fontSize: 20; 
		if: [ :each | each isStub not ] color: Color black;
		if: [:each | aCollection includes: each ] color: Color blue.
	view nodes: self.
	view shape line color: (Color gray alpha: 0.2); width: 3.
	view edges connectToAll: [:each | each providerUnits].
	view layout horizontalDominanceTree layered verticalGap: 50; horizontalGap: 50.
	view view elements @ RTSelectable new.
	view view pushBackEdges
]

{ #category : #ui }
FKDelphiScopingEntityGroup >> viewUsesOn: view [
	self viewUsesHighlighting: {} on: view
]
