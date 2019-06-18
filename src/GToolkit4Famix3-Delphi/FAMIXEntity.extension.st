Extension { #name : #FAMIXEntity }

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXEntity >> fkDelphiAST [
	^ self privateState attributeAt: #fkDelphiAST ifAbsent: [ nil ]
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXEntity >> fkDelphiAST: anAST [
	^ self privateState attributeAt: #fkDelphiAST put: anAST
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXEntity >> fkDelphiMooseName [
	^ self mooseName copyReplaceAll: '::' with: '.'
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXEntity >> mooseFinderASTIn: composite [
	<moosePresentationOrder: 20>
	composite tree
		title: 'AST';
		titleIcon: MooseIcons mooseAst;
		display: [ self fkDelphiAST ];
		format: [ :each | GTObjectPrinter new asTruncatedTextFrom: each ];
		children: [ :each | each children ];
		when: [ self fkDelphiAST notNil ]
]
