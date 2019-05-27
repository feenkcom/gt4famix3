Extension { #name : #FAMIXType }

{ #category : #'*GToolkit4Famix3' }
FAMIXType >> gtAttributesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Attributes';
		priority: 15;
		items: [ self attributes ];		
		column: 'Icon' translated do: [ :column | 
			column
				item: [ :each | each gtIcon ];
				rowStencil: [ :eachIcon | eachIcon asElement margin: (BlInsets left: 5 right: 5) ];
				noResize ];
		column: 'Name' translated format: [ :each | each gtDisplayString ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXType >> gtMethodsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Methods';
		priority: 10;
		items: [ self methods ];		
		column: 'Icon' translated do: [ :column | 
			column
				item: [ :each | each gtIcon ];
				rowStencil: [ :eachIcon | eachIcon asElement margin: (BlInsets left: 5 right: 5) ];
				noResize ];
		column: 'Name' translated format: [ :each | each gtDisplayString ]
]
