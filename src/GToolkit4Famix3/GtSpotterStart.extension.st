Extension { #name : #GtSpotterStart }

{ #category : #'*GToolkit4Famix3' }
GtSpotterStart >> spotterMooseModelsFor: aStep [
	<gtSearch>
	
	aStep listProcessor
		title: 'Moose Models';
		itemName: [ :pragma | pragma name ];
		filter: GtFilterSubstring item: [ :filter :context |
			MooseModel root allModels do: filter ];
		wantsToDisplayOnEmptyQuery: true
]
