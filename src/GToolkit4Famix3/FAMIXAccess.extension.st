Extension { #name : #FAMIXAccess }

{ #category : #'*GToolkit4Famix3' }
FAMIXAccess >> gtDefinitionSourceFor: aView [
	<gtView>
	^ aView forward
		title: 'Definition source';
		object: [ self to ];
		view: #gtSourceFor:
]
