Extension { #name : #FAMIXFolder }

{ #category : #'*GToolkit4Famix3' }
FAMIXFolder >> gtNestingFor: aView [
	<gtView>
	^ aView pannable 
		title: 'Map';
		stencil: [
			| treemap |
			treemap := GtTreeMap new
				roots: {self};
				deep: [ :folder | folder folders];
				leaves: [ :folder | folder files ];
				leavesSize: [ :file | file fileReference size / 100 ].
			treemap asElement
		]
]
