Extension { #name : #MooseEntity }

{ #category : #'*GToolkit4Famix3' }
MooseEntity >> gtPropertiesFor: aView [
	<gtView>
	(self mooseDescription notNil and: [ self mooseDescription allPrimitiveAttributes notEmpty]) ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Properties';
		items: [ self mooseDescription allPrimitiveAttributes ];
		sorted: [:x :y | x name < y name];
		column: 'Properties' evaluated: [:each | each name ];
		column: 'Value' evaluated: [:each :anObject | [(anObject mmGetProperty: each) asString] on: Error do: ['error'] ]
]
