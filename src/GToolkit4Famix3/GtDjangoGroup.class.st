Class {
	#name : #GtDjangoGroup,
	#superclass : #FAMIXBehaviouralEntityGroup,
	#category : #GToolkit4Famix3
}

{ #category : #'llm-generated' }
GtDjangoGroup >> gtDjangoDependenciesFor: aView [
	<gtView>
	^ aView mondrian
			 title: 'Dependencies';
			 priority: 10;
			 painting: [ :m |
				"Nodes: show the group's entities (e.g., classes, functions)"
				m nodes
					stencil: [ :c |
						BrLabel new
							when: BlClickEvent do: [ :e | e target phlow spawnObject: c ];
							aptitude: BrGlamorousLabelAptitude + (BrStyleCommonAptitude new
									 hovered: [ :aStyle | aStyle background: (BrGlamorousColors selectedListItemColor) ]);
							text: c name ];
					with: self.

				"Django URL patterns (path/re_path)"
				m edges
					toLeftCenter;
					fromRightCenter;
					stencil: [ :r |
						BlParabollaArcElement new
							when: BlClickEvent do: [ :e | e target phlow spawnObject: r ];
							zIndex: -1;
							curvatureFraction: 0.3;
							border: (BlBorder paint: (Color orange alpha: 0.5) width: 1);
							toHead: (BlArrowheadSimpleArrow new border: (BlBorder builder
								 paint: (Color orange alpha: 0.5);
								 width: 1;
								 build)) ];
					connect: self mooseModel allDjangoUrlInvocations
					from: #sender
					to: [ :inv | inv candidates isEmpty ifTrue: [ nil ] ifFalse: [ inv candidates anyOne ] ].

				"Django render(...) calls"
				m edges
					toLeftCenter;
					fromRightCenter;
					stencil: [ :r |
						BlParabollaArcElement new
							when: BlClickEvent do: [ :e | e target phlow spawnObject: r ];
							zIndex: -1;
							curvatureFraction: 0.3;
							border: (BlBorder paint: (Color green alpha: 0.5) width: 1);
							toHead: (BlArrowheadSimpleArrow new border: (BlBorder builder
								 paint: (Color green alpha: 0.5);
								 width: 1;
								 build)) ];
					connect: self mooseModel allDjangoRenderInvocations
					from: #sender
					to: [ :inv | inv candidates isEmpty ifTrue: [ nil ] ifFalse: [ inv candidates anyOne ] ].

				"Generic Python calls across the selected entities"
				m edges
					toLeftCenter;
					fromRightCenter;
					stencil: [ :r |
						BlParabollaArcElement new
							when: BlClickEvent do: [ :e | e target phlow spawnObject: r ];
							zIndex: -1;
							curvatureFraction: 0.3;
							border: (BlBorder paint: (Color blue alpha: 0.5) width: 2);
							toHead: (BlArrowheadSimpleArrow new border: (BlBorder builder
								 paint: (Color blue alpha: 0.5);
								 width: 2;
								 build)) ];
					connect: self
					fromAll: [ :e | e incomingInvocations collect: #from ]
					to: #yourself.

				m layout custom: GtGraphHorizontalDominanceTreeLayout new layered ]
]
