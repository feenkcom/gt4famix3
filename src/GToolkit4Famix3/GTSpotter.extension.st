Extension { #name : 'GTSpotter' }

{ #category : '*GToolkit4Famix3' }
GTSpotter >> spotterMooseModelsFor: aStep [
	<spotterOrder: 8>
	aStep listProcessor
		title: 'Moose Models';
		itemName: [ :pragma | pragma name ];
		filter: GTFilterSubstring item: [ :filter :context |
			MooseModel root allModels do: filter ];
		wantsToDisplayOnEmptyQuery: true
]
