Extension { #name : #FAMIXClass }

{ #category : #'*GToolkit4Famix3' }
FAMIXClass >> gtASTFor: aView [
	<gtView>
	self gtASTNode isNil ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'AST';
		object: [ self gtASTNode ];
		view: #gtExploreFor:
]

{ #category : #'*GToolkit4Famix3' }
FAMIXClass >> gtIcon [
	^ MooseIcons famixClass
]

{ #category : #'*GToolkit4Famix3' }
FAMIXClass >> gtIconName [
	^ #famixClass
]
