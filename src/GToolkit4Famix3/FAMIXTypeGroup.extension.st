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
FAMIXTypeGroup >> paintHierarchyWith: mondrian [
	mondrian nodes 
		stencil: [ :c | 
			BlElement new 
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
