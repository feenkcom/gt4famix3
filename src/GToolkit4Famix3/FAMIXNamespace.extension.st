Extension { #name : #FAMIXNamespace }

{ #category : #'*GToolkit4Famix3' }
FAMIXNamespace >> gtChildrenFor: aView [
	<gtView>
	^ aView tree
		title: 'Children';
		priority: 2;
		items: [{self}];
		stencil: [ :each | 
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
	^ aView pannable 
		title: 'Map';
		stencil: [
			GtNestedTreeMap new
				roots: {self};
				deep: [ :namespace | namespace childScopes];
				leaves: [ :namespace | namespace classes ];
				leavesSize: [ :class | class numberOfMethods ];
				containerEllipse: [ :ellipse :namespace | 
					| label scaledLabel |
					label := BlTextElement new 
						text: (namespace name asRopedText
							foreground: (Color white alpha: 0.7)).
					scaledLabel := label asScalableElement 
						zIndex: 10; 
						constraintsDo: [:c | 
							c horizontal matchParent. 
							c vertical matchParent. 
							c ignoreByLayout.
							c ignored horizontal weight: 0.2.
							c ignored horizontal alignCenter].
					ellipse addChild: scaledLabel.
					ellipse background: (Color gray alpha: 0.2) ] 	]
]
