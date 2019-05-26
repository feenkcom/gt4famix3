Extension { #name : #MooseGroup }

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
MooseGroup >> spotterItemsFor: aStep [
	<spotterOrder: 10>
	^ aStep listProcessor
		title: 'Items';
		candidatesLimit: 50;
		allCandidates: [ self entities ];
		itemName: [ :each | each gtDisplayString ];
		filter: GTFilterSubstring;
		wantsToDisplayOnEmptyQuery: true
]
