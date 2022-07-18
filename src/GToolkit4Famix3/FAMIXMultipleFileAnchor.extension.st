Extension { #name : #FAMIXMultipleFileAnchor }

{ #category : #'*GToolkit4Famix3' }
FAMIXMultipleFileAnchor >> gtCompleteSourceFor: aView [
	^ aView columnedList 
		title: 'Sources';
		priority: 20;
		items: [ self allFiles ];
		column: 'Source' translated
			icon: [ :eachItem |
				BrExpander new
					vFitContent;
					hMatchParent;
					collapse;
					margin: (BlInsets all: 10);
					aptitude: GtCoderExpanderAptitude new;
					header: [ BrLabel new aptitude: BrGlamorousLabelAptitude; text: eachItem gtDisplayString ];
					content: [ | container |
						container := BrFrame new 
							vExact: 400;
							hMatchParent;
							aptitude: BrGlamorousWithVerticalResizerAptitude;
							addChild: ((eachItem gtCompleteSourceFor: GtPhlowEmptyView new) asElement) matchParent ] ]
			weight: 1
]
