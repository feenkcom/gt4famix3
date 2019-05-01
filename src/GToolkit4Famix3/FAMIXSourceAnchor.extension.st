Extension { #name : #FAMIXSourceAnchor }

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceAnchor >> gtCompleteSourceFor: aView [
	<gtView>
	^ aView explicit
		title: 'Complete source';
		priority: 5;
		stencil: [ 
			| e text |
			text := self completeText asRopedText.
			(text from: self startPos to: self endPos) attributes: { 
				BlTextUnderlineAttribute new paint: Color blue }.
			e := BrEditor new text: text; look: BrGlamorousEditorLook new.
			e scrollToPosition: (self completeText lineNumberCorrespondingToIndex: self startPos).
			e 
			 ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceAnchor >> gtSourceFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Source';
		priority: 10;
		text: [ self sourceText ]
]
