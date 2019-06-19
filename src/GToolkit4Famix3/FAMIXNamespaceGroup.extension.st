Extension { #name : #FAMIXNamespaceGroup }

{ #category : #'*GToolkit4Famix3' }
FAMIXNamespaceGroup >> gtIcon [
	^ MooseIcons famixNamespaceGroup 
]

{ #category : #'*GToolkit4Famix3' }
FAMIXNamespaceGroup >> gtNestingFor: aView [
	<gtView>
	^ aView pannable 
		title: 'Map';
		stencil: [
			GtNestedTreeMap new
				roots: (self collectAsSet: #root) asArray;
				deep: [ :namespace | namespace childScopes];
				leaves: [ :namespace | namespace classes ];
				leavesSize: [ :class | class numberOfMethods ];
				containerEllipse: [ :ellipse :namespace | 
					(self includes: namespace) 
						ifTrue: [ 
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
							ellipse background: (Color gray alpha: 0.2) ] ];
				leafEllipse: [ :ellipse :class | 
					(self includes: class container) 
						ifFalse: [ ellipse background: (Color gray alpha: 0.2) ] ] ]
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
