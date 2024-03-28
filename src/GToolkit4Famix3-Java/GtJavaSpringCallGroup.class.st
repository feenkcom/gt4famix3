Class {
	#name : #GtJavaSpringCallGroup,
	#superclass : #MooseGroup,
	#instVars : [
		'projectCache'
	],
	#category : #'GToolkit4Famix3-Java'
}

{ #category : #accessing }
GtJavaSpringCallGroup >> callsFrom: fromProject to: toProject [
	^ self
		select: [ :each | 
			each parentPackage == fromProject
				and: [ each candidates anySatisfy: [ :can | can parentPackage == toProject ] ] ]
]

{ #category : #accessing }
GtJavaSpringCallGroup >> dbElement [
	^ BlElement new
		size: 50@30;
		addChild: (BlElement new
				size: 50 @ 20;
				relocate: 0 @ 5;
				border: Color lightGray);
		addChild: (BlElement new
				size: 50 @ 10;
				relocate: 0 @ 20;
				geometry: BlEllipseGeometry new;
				background: Color white;
				border: Color lightGray);
		addChild: (BlElement new
				size: 48 @ 20;
				relocate: 1 @ 5;
				background: Color white);
		addChild: (BlElement new
				size: 50 @ 10;
				geometry: BlEllipseGeometry new;
				background: Color white;
				border: Color lightGray)
]

{ #category : #accessing }
GtJavaSpringCallGroup >> fromProjects [
	^ self projectCache keys
]

{ #category : #accessing }
GtJavaSpringCallGroup >> gtItemsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Items';
		priority: 0;
		items: [ self entities ];
		column: 'Url'
			text: [ :each | (each to flatCollect: #fullPaths) ifEmpty: [ '' ] ifNotEmpty: #first ];
		column: 'Type'
			text: [ :each | 
				(each to collect: #type)
					ifEmpty: [ '' ]
					ifNotEmpty: [ :col | col anyOne ifNil: [ '' ] ] ]
			width: 50;
		column: 'Kind'
			text: [ :each | 
				| string |
				string := 'Regular'.
				each isFromJUnit4Test ifTrue: [ string := 'JUnit' ].
				string ]
			width: 50;
		column: 'Caller method'
			text: [ :each | 
				| text |
				text := each from gtDisplayText.
				each isInsideOfSameProject ifTrue: [ text italic ].
				text ]
]

{ #category : #accessing }
GtJavaSpringCallGroup >> projectCache [
	projectCache
		ifNil: [ projectCache := Dictionary new.
			self
				do: [ :each | 
					each candidates
						do: [ :cand | 
							each parentPackage ~~ cand parentPackage
								ifTrue: [ ((projectCache at: each parentPackage ifAbsentPut: [ Dictionary new ])
										at: cand parentPackage
										ifAbsentPut: [ self class new ]) add: each ] ] ] ].
	^ projectCache
]

{ #category : #accessing }
GtJavaSpringCallGroup >> toProjects [
	^ self
		inject: Set new
		into: [ :sum :each | 
			each candidates do: [ :can | sum add: can parentPackage ].
			sum ]
]

{ #category : #accessing }
GtJavaSpringCallGroup >> toProjectsFrom: aProject [
	^ (self projectCache at: aProject ifAbsent: [ Dictionary new ]) keys
]

{ #category : #accessing }
GtJavaSpringCallGroup >> updateTypeAccordingToEntities [
	projectCache := nil.
	^ super updateTypeAccordingToEntities
]
