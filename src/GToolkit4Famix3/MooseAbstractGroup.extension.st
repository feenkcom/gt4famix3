Extension { #name : 'MooseAbstractGroup' }

{ #category : '*GToolkit4Famix3' }
MooseAbstractGroup >> gtDisplayOn: aStream [ 
	super gtDisplayOn: aStream.
	aStream nextPut: $(. 
	aStream nextPutAll: self size printString. 
	aStream nextPut: $)
]

{ #category : '*GToolkit4Famix3' }
MooseAbstractGroup >> gtItemsFor: aView [
	<gtView>
	^ aView columnedList
		priority: 0;
		items: [ self entities
				sorted: [ :a :b | a gtDisplayString < b gtDisplayString ] ];
		"		send:
				[ :each | 
			each isNil
				ifTrue: [ nil ]
				ifFalse: [ each size = 1
						ifTrue: [ each first ]
						ifFalse: [ each asMooseGroup ] ] ];"
			title: 'Items';
		column: 'Icon' icon: [ :each | each gtIcon ];
		column: 'Name' translated text: [ :each | each gtDisplayString ]
]

{ #category : '*GToolkit4Famix3' }
MooseAbstractGroup >> gtNavigationItems [
	
	^ super gtNavigationItems
]
