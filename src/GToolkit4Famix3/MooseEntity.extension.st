Extension { #name : #MooseEntity }

{ #category : #'*GToolkit4Famix3' }
MooseEntity >> gtNavigationFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Navigation';
		priority: 1;
		items: [ self gtNavigationItems ];
		column: 'Name' do: [:aColumn | aColumn item: [:assoc | assoc key ] ];
		column: 'Value' do: [:aColumn | aColumn item: [:assoc | assoc value gtDisplayString ] ];
		send: [:assoc | assoc value]
]

{ #category : #'*GToolkit4Famix3' }
MooseEntity >> gtNavigationItems [
	^ (self mooseDescription allAttributes reject: [ :attribute | attribute type isPrimitive]) 
		collect: [ :attribute | 
			| value |
			value := self mmGetProperty: attribute.
			(value isCollection and: [ value size = 1 ]) ifTrue: [ value := value anyOne ].
			value isCollection ifTrue: [ value := value asMooseGroup ].
			attribute name -> value ]
		thenReject: [ :assoc | 
			assoc value isNil or: [
				assoc value isCollection and: [ assoc value isEmpty ] ] ]
]

{ #category : #'*GToolkit4Famix3' }
MooseEntity >> gtPropertiesFor: aView [
	<gtView>
	(self mooseDescription notNil and: [ self mooseDescription allPrimitiveAttributes notEmpty]) ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Properties';
		items: [ self mooseDescription allPrimitiveAttributes sorted: [:x :y | x name < y name]];
		column: 'Properties' evaluated: [:each | each name ];
		column: 'Value' evaluated: [:each | [(self mmGetProperty: each) asString] on: Error do: [ :e | e printString ] ]
]
