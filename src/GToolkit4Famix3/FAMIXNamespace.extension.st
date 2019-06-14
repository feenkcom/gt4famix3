Extension { #name : #FAMIXNamespace }

{ #category : #'*GToolkit4Famix3' }
FAMIXNamespace >> gtChildrenFor: aView [
	<gtView>
	^ aView tree
		title: 'Children';
		priority: 2;
		items: [{self}];
		itemStencil: [ :each | 
			BlElement new
				constraintsDo: [ :c | 
					c horizontal fitContent. 
					c vertical fitContent ];
				layout: BlLinearLayout horizontal;
				addChild: each gtIcon asElement;
				addChild: (BrLabel new
					look: BrGlamorousListLabelLook;
					text: each name asRopedText) ];
		children: [ :each | 
			each structuralChildren sorted: [:entity1 :entity2 | 
				entity1 name < entity2 name] ]
]

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
