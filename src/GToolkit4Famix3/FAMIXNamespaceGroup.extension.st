Extension { #name : #FAMIXNamespaceGroup }

{ #category : #'*GToolkit4Famix3' }
FAMIXNamespaceGroup >> gtIcon [
	^ MooseIcons famixNamespaceGroup 
]

{ #category : #'*GToolkit4Famix3' }
FAMIXNamespaceGroup >> paintTreeWith: m [
	m nodes 
		stencil: [ :each | BlTextElement new text: each name asRopedText glamorousRegularSize ];
		with: self.
	m edges 
		fromRightCenter;
		toLeftCenter;
		connectFrom: #parentScope.
	m layout horizontalTree layered.
]
