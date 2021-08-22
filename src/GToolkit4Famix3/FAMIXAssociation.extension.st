Extension { #name : 'FAMIXAssociation' }

{ #category : '*GToolkit4Famix3' }
FAMIXAssociation >> findASTNode [
	^ super findASTNode
		ifNil: [ | start stop innerNode |
			self from isNil
				ifTrue: [ ^ nil ].
			start := self propertyNamed: #astStartPosition ifAbsent: [ ^ nil ].
			stop := self propertyNamed: #astStopPosition ifAbsent: [ ^ nil ].
			self from gtASTNode
				ifNotNil: [ :node | 
					node
						withAllNodesDo: [ :each | 
							(start >= each startPosition and: [ stop <= each stopPosition ])
								ifTrue: [ innerNode := each ] ] ].
			innerNode ]
]
