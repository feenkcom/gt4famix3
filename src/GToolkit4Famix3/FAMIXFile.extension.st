Extension { #name : #FAMIXFile }

{ #category : #'*GToolkit4Famix3' }
FAMIXFile >> gtPathFor: aView [

	<gtView>
	name ifNil: [ ^ aView empty ].
	^ aView forward
		  title: 'Path';
		  object: [ self fileReference ];
		  view: #gtPathFor:
]
