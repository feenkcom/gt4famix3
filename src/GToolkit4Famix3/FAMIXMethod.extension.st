Extension { #name : 'FAMIXMethod' }

{ #category : '*GToolkit4Famix3' }
FAMIXMethod >> gtIcon [ 
	^ MooseIcons famixMethod
]

{ #category : '*GToolkit4Famix3' }
FAMIXMethod >> mavenDirectory [
	^ self sourceAnchor ifNotNil: [ :anchor | 
		anchor fileReference mavenDirectory ]
]
