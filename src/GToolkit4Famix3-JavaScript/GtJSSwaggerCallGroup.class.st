Class {
	#name : #GtJSSwaggerCallGroup,
	#superclass : #MooseGroup,
	#category : #'GToolkit4Famix3-JavaScript'
}

{ #category : #'gt - extensions' }
GtJSSwaggerCallGroup >> gtItemsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Items';
		priority: 0;
		items: [ self entities ];
		column: 'Type'
			text: [ :each | each requestType ifNil: [ '' ] ]
			width: 60;
		column: 'URL'
			text: [ :each | each resolvedUrl ifNil: [ '' ] ]
			weight: 2;
		column: 'Caller project'
			text: [ :each | 
				| text |
				text := each fromProject gtDisplayText.
				each isInsideOfSameProject ifTrue: [ text italic ].
				text ];
		column: 'Receiver project'
			text: [ :each | 
				| text |
				text := each toProjects
						ifEmpty: [ '' asRopedText ]
						ifNotEmpty: [ :col | String streamContents: [ :stream | col do: [ :e | stream nextPutAll: e gtDisplayString ] separatedBy: [ stream nextPutAll: ', ' ] ] ].
				each isInsideOfSameProject ifTrue: [ text italic ].
				text ]
]
