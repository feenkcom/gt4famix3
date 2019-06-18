Class {
	#name : #FKDelphiUnitGroup,
	#superclass : #FKDelphiScopingEntityGroup,
	#category : #'GToolkit4Famix3-Delphi-Importer'
}

{ #category : #meta }
FKDelphiUnitGroup class >> annotation [
	<MSEClass: #UnitGroup super: #FKDelphiScopingEntityGroup>
	<package: #Delphi>
	^self
]

{ #category : #ui }
FKDelphiUnitGroup >> mooseFinderUsesIn: composite [
	<moosePresentationOrder: 40>
	composite roassal2
		title: 'Uses';
		titleIcon: MooseIcons mooseCluster;
		initializeView: [ RTMondrian new ];
		painting: [ :view | self viewUsesOn: view ]
]

{ #category : #'as yet unclassified' }
FKDelphiUnitGroup >> viewUsagesOfTranslationOnProjectDependencyMapOn: view [
	| grouped view |
	grouped := self groupedBy: [ :each | (each sourceAnchor fileName piecesCutWhere: [ :a :b | a = $/ ]) third ].
	view shape label 
		text: [:each | each name removeSuffix: '/']; 
		if: [:assoc | assoc value anySatisfy: [:unit | unit providerUnits anySatisfy: [ :p | p name includesSubstring: 'Translation' ] ] ] color: Color blue.
	view nodes: grouped associations.
	view shape line color: (Color gray alpha: 0.2).
	view edges connectFromAll: [ :assoc | assoc value flatCollectAsSet: [ :unit | unit clientUnits collect: [ :each | grouped associationAt: (each sourceAnchor fileName piecesCutWhere: [ :a :b | a = $/ ]) third ] ] ].
	view layout horizontalDominanceTree layered verticalGap: 20.
	view 
]

{ #category : #ui }
FKDelphiUnitGroup >> viewUsesHighlighting: aCollection on: view [
	view shape label text: #name; if: [:each | aCollection includes: each ] color: Color blue.
	view nodes: self.
	view shape line color: (Color gray alpha: 0.2).
	view edges connectToAll: [:each | each providerUnits].
	view layout horizontalDominanceTree layered.
	view view pushBackEdges
]

{ #category : #ui }
FKDelphiUnitGroup >> viewUsesOn: view [
	self viewUsesHighlighting: {} on: view
]
