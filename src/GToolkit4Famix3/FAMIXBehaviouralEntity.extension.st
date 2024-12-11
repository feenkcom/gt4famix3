Extension { #name : #FAMIXBehaviouralEntity }

{ #category : #'*GToolkit4Famix3' }
FAMIXBehaviouralEntity >> gtOutgoingReferencesFor: aView [
	<gtView>
	outgoingReferences ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Outgoing references';
		items: [ outgoingReferences ];
		column: 'Reference target' text: [ :each | each to gtDisplayString ]
]
