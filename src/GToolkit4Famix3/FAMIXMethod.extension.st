Extension { #name : #FAMIXMethod }

{ #category : #'*GToolkit4Famix3' }
FAMIXMethod >> gtASTFor: aView [
	<gtView>
	self gtASTNode isNil ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'AST';
		object: [ self gtASTNode ];
		view: #gtExploreFor:
]

{ #category : #'*GToolkit4Famix3' }
FAMIXMethod >> gtIcon [ 
	^ MooseIcons famixMethod
]

{ #category : #'*GToolkit4Famix3' }
FAMIXMethod >> gtIconName [
	^ #famixMethod
]

{ #category : #'*GToolkit4Famix3' }
FAMIXMethod >> mavenDirectory [
	^ self sourceAnchor ifNotNil: [ :anchor | 
		anchor fileReference mavenDirectory ]
]
