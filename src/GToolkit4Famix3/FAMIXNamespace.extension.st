Extension { #name : #FAMIXNamespace }

{ #category : #'*GToolkit4Famix3' }
FAMIXNamespace >> gtIcon [
	^ MooseIcons famixNamespace
]

{ #category : #'*GToolkit4Famix3' }
FAMIXNamespace >> gtNestingFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Map';
		stencil: [
			| treemap |
			treemap := GtTreeMap new
				roots: self;
				deep: [ :namespace | namespace childScopes];
				leaves: [ :namespace | namespace classes ];
				leavesSize: [ :class | class numberOfMethods ].
			treemap asElement asPannableElement
		]
]
