Extension { #name : #MooseGroupRuntimeStorage }

{ #category : #'*GToolkit4Famix3' }
MooseGroupRuntimeStorage >> gtByTypeFor: aView [

	<gtView>
	^ aView tree
		  title: 'By type';
		  items: [ 
			  byType associations collect: [ :assoc | 
					  assoc key -> assoc value asMooseGroup ] ];
		  itemText: [ :assoc | 
			  assoc isAssociation
				  ifTrue: [ 
					  assoc key gtDisplayString , '(' , assoc value size asString
					  , ')' ]
				  ifFalse: [ assoc gtDisplayString ] ];
		  children: [ :assoc | 
			  assoc isAssociation
				  ifTrue: [ assoc value ]
				  ifFalse: [ {  } ] ];
		  send: #value
]
