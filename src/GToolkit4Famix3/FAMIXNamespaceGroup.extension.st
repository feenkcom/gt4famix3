Extension { #name : #FAMIXNamespaceGroup }

{ #category : #'*GToolkit4Famix3' }
FAMIXNamespaceGroup >> gtIcon [
	^ MooseIcons famixNamespaceGroup 
]

{ #category : #'*GToolkit4Famix3' }
FAMIXNamespaceGroup >> gtNestingFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Map';
		stencil: [
			| treemap |
			treemap := GtTreeMap new
				roots: (self select: [:each | each isRoot]);
				deep: [ :namespace | namespace childScopes];
				leaves: [ :namespace | namespace classes ];
				leavesSize: [ :class | class numberOfMethods ].
			treemap asElement asPannableElement
		]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXNamespaceGroup >> paintTreeWith: m [
	m nodes 
		stencil: [ :each | BlTextElement new text: each name asRopedText glamorousRegularSize ];
		with: self.
	m edges 
		fromRightCenter;
		toLeftCenter;
		connectFrom: #parentScope.
	m layout horizontalTree layered.
]
