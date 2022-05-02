Extension { #name : #FAMIXIndexedFileEntityAnchor }

{ #category : #'*GToolkit4Famix3' }
FAMIXIndexedFileEntityAnchor >> gtPathFor: aView [

	<gtView>
	self correspondingFile ifNil: [ ^ aView empty ].
	
	^ aView forward
		  title: 'Path';
		  object: [ self fileReference ];
		  view: #gtPathFor:
]
