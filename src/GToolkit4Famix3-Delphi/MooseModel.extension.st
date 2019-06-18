Extension { #name : #MooseModel }

{ #category : #'*GToolkit4Famix3-Delphi' }
MooseModel >> allDelphiFiles [
	^ self allDelphiUnits allFiles, self allDelphiPrograms allFiles
]

{ #category : #'*GToolkit4Famix3-Delphi' }
MooseModel >> delphiUnknownUnit [
	^ self allDelphiUnits entityNamed: FKDelphiUnit unknownUnitName
]

{ #category : #'*GToolkit4Famix3-Delphi' }
MooseModel >> mooseFinderDelphiProgramsNestingIn: composite [
	<moosePresentationOrder: 40>
	composite roassal2
		title: 'Delphi programs nesting';
		titleIcon: MooseIcons mooseCircularTreeMap;
		initializeView: [ RTCircularTreeMapBuilder new ];
		painting: [ :b |
			b shape
				color: Color transparent;
				borderColor: Color veryLightGray;
				borderWidth: 2;
				if: [ :f | f extension notEmpty ] color: (Color veryLightGray);
				if: [ :f | f extension = 'pas' and: [ self allDelphiFiles includes: f ] ] color: (Color blue alpha: 0.5);
				if: [ :f | f extension = 'dpr' and: [ self allDelphiFiles includes: f ] ] color: (Color red alpha: 0.5).	
			b
				baseradius: 1000;
				leafWeight: [:f | f size sqrt ]; 
				explore: self rootFolder parent
				nesting: #directories
				leaves: [:each | each files select: [ :f | #('pas' 'dpr') includes: f extension ] ] ]
]
