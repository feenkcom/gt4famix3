Class {
	#name : #GtOpenApiPathGroup,
	#superclass : #MooseGroup,
	#category : #'GToolkit4Famix3-OpenApi'
}

{ #category : #accessing }
GtOpenApiPathGroup >> gtItemsFor: aView [
	^ aView columnedList
		priority: 0;
		items: [ self entities
				sorted: [ :a :b | 
					a endPoint < b endPoint
						or: [ a endPoint = b endPoint and: [ a method < b method ] ] ] ];
		title: 'Items';
		column: 'Path' text: #endPoint;
		column: 'Method'
			text: #method
			width: 75
]
