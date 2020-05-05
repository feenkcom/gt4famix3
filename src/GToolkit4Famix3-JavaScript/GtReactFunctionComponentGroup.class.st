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
				stencil: [:c | 
					BrLabel new
						when: BlClickEvent do: [:e | e target phlow spawnObject: c];
						look: BrGlamorousLabelLook;
						text: c name];
				with: self.
			m edges 
				toLeftCenter;
				fromRightCenter;
				stencil: [:r | 
					BlParabollaArcElement new 
						when: BlClickEvent do: [:e | e target phlow spawnObject: r];
						zIndex: -1;
						curvatureFraction: 0.3;
						border: (BlBorder paint: (Color orange alpha: 0.5) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color orange alpha: 0.5); width: 2; build)) ];
				connect: self mooseModel allReactComponentReferences from: #sender to: [:r | r candidates isEmpty ifTrue: [nil] ifFalse: [r candidates anyOne]].
			m layout custom: (GtGraphHorizontalDominanceTreeLayout new layered).
		]
]
