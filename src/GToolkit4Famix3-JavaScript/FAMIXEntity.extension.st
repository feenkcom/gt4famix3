Extension { #name : #FAMIXEntity }

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXEntity >> fkJsAST [
	^ self propertyNamed: #ast
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXEntity >> fkJsAST: anAST [
	^ self propertyNamed: #ast put: anAST
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXEntity >> isJSScript [
	^ false
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXEntity >> mooseFinderFKJsASTIn: composite [
	<moosePresentationOrder: 20>
	composite tree
		title: 'AST';
		titleIcon: MooseIcons mooseAst;
		display: [ self fkJsAST ];
		format: [ :each | GTObjectPrinter new asTruncatedTextFrom: each ];
		children: [ :each | each children ];
		when: [ self fkJsAST notNil ]
]
