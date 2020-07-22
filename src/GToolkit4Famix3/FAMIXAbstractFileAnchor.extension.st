Extension { #name : #FAMIXAbstractFileAnchor }

{ #category : #'*GToolkit4Famix3' }
FAMIXAbstractFileAnchor >> gtAddLinksTo: text [
	| associations |
	self correspondingFile ifNil: [ ^ self ].
	associations := OrderedCollection new.
	self correspondingFile entities
		do: [ :each | 
			each
				gtLinksForFile: self fileReference
				do: [ :entity :start :stop | 
					stop < start
						ifFalse: [ associations add: (start to: stop) -> entity ] ] ].
	associations
		sort: [ :a :b | 
			a key first < b key first
				or: [ a key first = b key first and: [ a key last > b key last ] ] ].
	associations
		do: [ :each | 
			(text from: each key first to: each key last)
				clearAttributes: [ :attr | 
					attr class == BrTextHoverStylableAttribute
						or: [ attr class == BrTextClickAttribute ] ];
				attributes:
					{(BrTextHoverStylableAttribute new
						beNotOverwritableByStyler;
						attribute: (BlTextUnderlineAttribute new paint: BrGlamorousColors linkColor)).
					(BrTextClickAttribute new
						beNotOverwritableByStyler;
						action:
								[ :aText :aTarget :aTextEditor :anEvent | aTarget phlow selectObject: each value ])} ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXAbstractFileAnchor >> gtCompleteSourceFor: aView [
	<gtView> 
	self completeText isEmpty
		ifTrue: [ ^ aView empty ].
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
			e
				scrollToPosition: (self completeText lineNumberCorrespondingToIndex: self startPos).
			e ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXAbstractFileAnchor >> gtText [
	| text |
	text := BlRopedRawText string: self completeText.
	(text from: self startPos to: self endPos)
		attributes:
			{(BlTextHighlightAttribute new
				beNotOverwritableByStyler;
				paint: (BrGlamorousColors neutralBackgroundColor))}.
	self gtAddLinksTo: text.
	^ text
]
