Class {
	#name : #GtReactFunctionComponentGroup,
	#superclass : #FAMIXBehaviouralEntityGroup,
	#category : #'GToolkit4Famix3-JavaScript-React'
}

{ #category : #accessing }
GtReactFunctionComponentGroup >> gtReactDependenciesFor: aView [

	<gtView>
	^ aView mondrian
		  title: 'Dependencies';
		  priority: 10;
		  painting: [ :m | 
			  m nodes
				  stencil: [ :c | 
					  BrLabel new
						  when: BlClickEvent do: [ :e | e target phlow spawnObject: c ];
						  aptitude: BrGlamorousLabelAptitude + (BrStyleCommonAptitude new
										hovered: [ :aStyle | aStyle background: (BrGlamorousColors selectedListItemColor) ]);
						  text: c name ];
				  with: self.

			  "React calls"
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
				  connect: self mooseModel allReactComponentReferences
				  from: #sender
				  to: [ :r | 
					  r candidates isEmpty
						  ifTrue: [ nil ]
						  ifFalse: [ r candidates anyOne ] ].

			  "JavaScript calls"
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
				  fromAll: [ :r | r incomingInvocations collect: #from ]
				  to: #yourself.

			  m layout custom: GtGraphHorizontalDominanceTreeLayout new layered ]
]
