Extension { #name : #FMMetaRepository }

{ #category : #'*GToolkit4Famix3' }
FMMetaRepository >> gtGtSpotterClassesFor: aStep [
	<gtSearch>
	aStep listProcessor
		priority: 10;
		title: 'Classes';
		allCandidates: [ self classes ];
		itemName: [ :class | class fullName ];
		filter: GTFilterSubstring
]

{ #category : #'*GToolkit4Famix3' }
FMMetaRepository >> gtGtSpotterPackagesFor: aStep [
	<gtSearch>
	aStep listProcessor
		priority: 20;
		title: 'Packages';
		allCandidates: [ self packages ];
		itemName: [ :example | example fullName ];
		filter: GTFilterSubstring
]
