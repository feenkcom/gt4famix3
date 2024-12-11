Extension { #name : #FAMIXAssociationGroup }

{ #category : #'*GToolkit4Famix3' }
FAMIXAssociationGroup >> gtItemsFor: aView [
	<gtView>
	^ aView columnedList
		priority: 0;
		items: [ self entities sorted: [ :a :b | a gtDisplayString < b gtDisplayString ] ];
		title: 'Items';
		column: 'Icon'
			iconName: [ :each | each gtIconName ]
			width: 36;
		column: 'From' translated text: [ :each | each fromDisplayString ];
		column: 'To' translated text: [ :each | each toDisplayString ]
]
