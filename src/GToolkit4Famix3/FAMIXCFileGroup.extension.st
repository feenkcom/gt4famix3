Extension { #name : #FAMIXCFileGroup }

{ #category : #'*GToolkit4Famix3' }
FAMIXCFileGroup >> gtIncludesOn: aView [
	<gtView>
	^ aView mondrian
		title: 'Includes';
		painting: [ :m | self paintIncludesWith: m ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXCFileGroup >> paintIncludesWith: m [
	| grouped |
	grouped := self groupedBy: [:each | each basenameWithoutExtension].
	m nodes 
		stencil: [:each | BrLabel new look: BrGlamorousLabelLook; text: each anyOne 			basenameWithoutExtension asRopedText ];
		with: grouped values.
	m edges 
		fromRightCenter;
		toLeftCenter;
		stencil: [ :each | 
			BlParabollaArcElement new 
				border: (BlBorder paint: (Color gray alpha: 0.4) width: 2);
				zIndex: -1;
				curvatureFraction: 0.2;
				toHead: (BlArrowheadSimpleArrow new
					border: (BlBorder builder paint: (Color gray alpha: 0.4); width: 2; build))];
		connect: self 
		from: [:each |
			grouped at: (each basenameWithoutExtension)]
		toAll: [:f | 
			f includedFiles collectAsSet: [:each |
				grouped at: (each basenameWithoutExtension)] ].
	m layout horizontalTree.
	m
]
