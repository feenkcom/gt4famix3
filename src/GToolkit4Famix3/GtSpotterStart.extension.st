Extension { #name : #GtSpotterStart }

{ #category : #'*GToolkit4Famix3' }
GtSpotterStart >> gtSearchMooseModelsFor: aSearch [
	<gtSearch>
	^ aSearch list
		title: 'Moose Models';
		items: [ MooseModel root allModels ];
		itemName: [ :pragma | pragma name ];
		filterBySubstring;
		wantsToDisplayOnEmptyQuery: true
]
