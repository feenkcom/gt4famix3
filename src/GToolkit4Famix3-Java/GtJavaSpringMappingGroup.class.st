Class {
	#name : #GtJavaSpringMappingGroup,
	#superclass : #MooseGroup,
	#category : #'GToolkit4Famix3-Java'
}

{ #category : #accessing }
GtJavaSpringMappingGroup >> gtCoveredFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Coverage';
		priority: 0.5;
		items: [ self entities
				sorted: [ :a :b | 
					(a paths ifEmpty: [ '' ] ifNotEmpty: #first)
						< (b paths ifEmpty: [ '' ] ifNotEmpty: #first) ] ];
		column: 'Url' text: [ :each | each paths ifEmpty: [ '' ] ifNotEmpty: #first ];
		column: 'Type'
			text: [ :each | each type ifNil: [ '' ] ]
			width: 50;
		column: 'Regular calls'
			text: [ :each | 
				| s |
				s := (each incomingCalls reject: [ :c | c isFromJUnit4Test ]) size.
				s isZero ifTrue: [ '' ] ifFalse: [ s ] ];
		column: 'JUnit calls'
			text: [ :each | 
				| s |
				s := (each incomingCalls select: [ :c | c isFromJUnit4Test ]) size.
				s isZero ifTrue: [ '' ] ifFalse: [ s ] ]
]

{ #category : #accessing }
GtJavaSpringMappingGroup >> gtItemsFor: aView [
	^ aView columnedList
		title: 'Items';
		priority: 0;
		items: [ self entities
				sorted: [ :a :b | 
					(a paths ifEmpty: [ '' ] ifNotEmpty: #first)
						< (b paths ifEmpty: [ '' ] ifNotEmpty: #first) ] ];
		column: 'Url' text: [ :each | each paths ifEmpty: [ '' ] ifNotEmpty: #first ];
		column: 'Type'
			text: [ :each | each type ifNil: [ '' ] ]
			width: 50;
		column: 'Regular calls'
			text: [ :each | 
				| s |
				s := (each incomingCalls reject: [ :c | c isFromJUnit4Test ]) size.
				s isZero ifTrue: [ '' ] ifFalse: [ s ] ]
			width: 80;
		column: 'JUnit calls'
			text: [ :each | 
				| s |
				s := (each incomingCalls select: [ :c | c isFromJUnit4Test ]) size.
				s isZero ifTrue: [ '' ] ifFalse: [ s ] ]
			width: 80;
		column: 'Method' text: [ :each | each gtJavaSpringEntity gtDisplayString ]
]
