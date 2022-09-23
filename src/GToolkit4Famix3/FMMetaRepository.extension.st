Extension { #name : #FMMetaRepository }

{ #category : #'*GToolkit4Famix3' }
FMMetaRepository >> gtGtSpotterClassesFor: aSearch [
	<gtSearch>
	^ aSearch list
		priority: 10;
		title: 'Classes';
		items: [ self classes ];
		itemName: [ :class | class fullName ];
		filterBySubstring
]

{ #category : #'*GToolkit4Famix3' }
FMMetaRepository >> gtGtSpotterPackagesFor: aSearch [
	<gtSearch>
	^ aSearch list
		priority: 20;
		title: 'Packages';
		items: [ self packages ];
		itemName: [ :example | example fullName ];
		filterBySubstring
]
