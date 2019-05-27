Extension { #name : #MooseModel }

{ #category : #'*GToolkit4Famix3' }
MooseModel >> gtItemsFor: aView [
	^ aView empty
]

{ #category : #'*GToolkit4Famix3' }
MooseModel >> spotter: aStringTitle on: aCandidatesBlock for: aStep [
	aCandidatesBlock value isEmpty ifTrue: [ ^ self ].
	^ aStep listProcessor
		title: aStringTitle;
		candidatesLimit: 5;
		allCandidates: aCandidatesBlock;
		itemName: [ :each | each mooseName ];
"		itemIcon: [ :each | each mooseIcon ];"
		actLogic: [ :each :step |
			step exit.
			GtInspector openOn: each ];
		filter: GTFilterSubstring;
		wantsToDisplayOnEmptyQuery: true
]

{ #category : #'*GToolkit4Famix3' }
MooseModel >> spotterClassesFor: aStep [
	<spotterOrder: 20>
	self spotter: 'All classes' on: [ self allClasses ] for: aStep
]

{ #category : #'*GToolkit4Famix3' }
MooseModel >> spotterMethodsFor: aStep [
	<spotterOrder: 30>
	self spotter: 'All methods' on: [ self allMethods ] for: aStep
]
