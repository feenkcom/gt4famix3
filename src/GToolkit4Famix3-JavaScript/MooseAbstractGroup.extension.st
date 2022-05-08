Extension { #name : #MooseAbstractGroup }

{ #category : #'*GToolkit4Famix3-JavaScript' }
MooseAbstractGroup >> allReactComponentReferences [
	<navigation: 'All React component references'>
	^ self allWithType: GtReactComponentReference
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
MooseAbstractGroup >> allReactComponents [
	<navigation: 'All React components'>
	^ self allWithType: GtReactFunctionComponent
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
MooseAbstractGroup >> gtReactDependenciesFor: aView [

	^ aView empty
]
