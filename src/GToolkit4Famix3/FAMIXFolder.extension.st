Extension { #name : 'FAMIXFolder' }

{ #category : '*GToolkit4Famix3' }
FAMIXFolder >> gtFilesFor: aView [
	<gtView>
	^ aView list 
		title: 'Items';
		priority: 0;
		items: [ (self folders sorted: [:a :b | a name < b name ]), (self files sorted: [:a :b | a name < b name ]) ];
		itemFormat: #name
]

{ #category : '*GToolkit4Famix3' }
FAMIXFolder >> gtNestingFor: aView [
	<gtView>
	^ aView pannable 
		title: 'Map';
		stencil: [
			| treemap |
			treemap := GtNestedTreeMap new
				roots: {self};
				deep: [ :folder | folder folders];
				leaves: [ :folder | folder files ];
				leavesSize: [ :file | file fileReference size / 100 ].
			treemap asElement
		]
]
