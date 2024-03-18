Extension { #name : #MooseAbstractGroup }

{ #category : #'*GToolkit4Famix3' }
MooseAbstractGroup >> gtDisplayOn: aStream [ 
	super gtDisplayOn: aStream.
	aStream nextPut: $(. 
	aStream nextPutAll: self size printString. 
	aStream nextPut: $)
]

{ #category : #'*GToolkit4Famix3' }
MooseAbstractGroup >> gtItemsFor: aView [
	<gtView>
	^ aView columnedList
		priority: 0;
		items: [ self entities sorted: [ :a :b | a gtDisplayString < b gtDisplayString ] ];
		title: 'Items';
		column: 'Icon'
			iconName: [ :each | each gtIconName ]
			width: 36;
		column: 'Name' translated text: [ :each | each gtDisplayString ]
]

{ #category : #'*GToolkit4Famix3' }
MooseAbstractGroup >> gtNavigationItems [
	
	^ super gtNavigationItems
]
