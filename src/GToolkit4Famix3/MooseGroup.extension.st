Extension { #name : #MooseGroup }

{ #category : #'*GToolkit4Famix3' }
MooseGroup >> asBrItemsProvider [
	^ BrSequenceableCollectionItemsProvider forCollection: self
]

{ #category : #'*GToolkit4Famix3' }
MooseGroup >> gtByTypeFor: aView [
	<gtView>
	^ aView forward
		title: 'By Type';
		object: storage;
		view: #gtByTypeFor:
]

{ #category : #'*GToolkit4Famix3' }
MooseGroup >> gtDisplayOn: stream [
	stream 
			nextPutAll: self description; 
			space; 
			nextPut: $(; 
			print: self size;
			nextPut: $)
]

{ #category : #'*GToolkit4Famix3' }
MooseGroup >> gtIcon [
	^ MooseIcons mooseMetamodelGroup
]

{ #category : #'*GToolkit4Famix3' }
MooseGroup >> gtSpotterItemsFor: aSearch [
	<gtSearch>
	^ aSearch list
		priority: 10;
		title: 'Items';
		items: [ self entities ];
		itemName: [ :each | each gtDisplayString ];
		itemsLimit: 50;
		filterBySubstring;
		wantsToDisplayOnEmptyQuery: true
]
