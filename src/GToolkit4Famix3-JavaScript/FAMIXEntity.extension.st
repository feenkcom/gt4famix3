Extension { #name : #FAMIXEntity }

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXEntity >> fkJsAST [
	^ self privateState attributeAt: #fkJsAST ifAbsent: [ nil ]
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXEntity >> fkJsAST: anAST [
	^ self privateState attributeAt: #fkJsAST put: anAST
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
