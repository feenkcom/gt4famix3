Extension { #name : #MooseModel }

{ #category : #'*GToolkit4Famix3-Python' }
MooseModel >> allDjangoUrlInvocations [
	<navigation: 'All Django URL invocations'>
	^ self allInvocations select: [ :i | (i propertyNamed: #djangoUrl) = true ]
]
