Extension { #name : #FAMIXTypeGroup }

{ #category : #'*GToolkit4Famix3' }
FAMIXTypeGroup >> gtBlueprintHierarchyFor: aView [
	<gtView>
	^ aView explicit
		title: 'Blueprint';
		priority: 6;
		stencil: [ 
			(FAMIXClassBlueprint new 
				types: self;
				asElement) asPannableElement ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXTypeGroup >> gtHierarchyFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Hierarchy';
		priority: 5;
		painting: [ :m | self paintHierarchyWith: m ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXTypeGroup >> gtWithinNestingMapFor: aView [
	<gtView>
	^ aView explicit
		title: 'Within nesting and clients';
		priority: 6;
		stencil: [ 
			| callers treemap |
			callers := (self flatCollectAsSet: #clientTypes) \ self.
			treemap := GtNestedTreeMap new
				roots: (self mooseModel allModelNamespaces collectAsSet: #root) asArray;
				deep: [ :namespace | namespace childScopes];
				leaves: [ :namespace | namespace classes ];
				leavesSize: [ :class | class numberOfMethods ];
				leafEllipse: [ :ellipse :class | 
					(self includes: class) 
						ifTrue: [ ellipse background: (Color blue alpha: 0.2) ]
						ifFalse: [ 
							(callers includes: class)
								ifTrue: [ ellipse background: (Color red alpha:0.8) ]
								ifFalse: [ ellipse background: (Color gray alpha: 0.2) ] ] ].
			treemap asElement asPannableElement ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXTypeGroup >> paintHierarchyWith: mondrian [
	mondrian nodes 
		stencil: [ :c | 
			BlElement new 
				zIndex: 10;
				border: (BlBorder paint: (Color black alpha: 0.5) width: 2);
				width: (c numberOfAttributes max: 5);
				height: (c numberOfMethods max: 5)];
		with: self.
	mondrian edges 
		fromCenterBottom;
		toCenterTop;
		connectFrom: #superclass.
	mondrian layout custom: (GtGraphTreeLayout new).
]
