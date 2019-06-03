Extension { #name : #FAMIXSourceAnchor }

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceAnchor >> gtAddLinksTo: text [
	
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceAnchor >> gtCompleteSourceFor: aView [
	<gtView>
	^ aView explicit
		title: 'Complete source';
		priority: 5;
		stencil: [ | e text |
			text := self gtText.
			e := BrEditor new
				text: text;
				look: BrGlamorousCodeEditorLook new.
			element notNil
				ifTrue: [ element gtStyler ifNotNil: [ :styler | e styler: styler ] ].
			e scrollToPosition: (self completeText lineNumberCorrespondingToIndex: self startPos).
			e ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceAnchor >> gtSourceFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Source';
		priority: 10;
		text: [ self sourceText ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceAnchor >> gtText [
	| text |
	text := self completeText asRopedText.
	(text from: self startPos to: self endPos)
		attributes:
			{(BlTextUnderlineAttribute new
				beNotOverwritableByStyler;
				paint: (Color lightGray alpha: 0.5);
				width: 1)}.
	self gtAddLinksTo: text.
	^ text
]
