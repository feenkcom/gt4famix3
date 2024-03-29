Extension { #name : #FAMIXAbstractFileAnchor }

{ #category : #'*GToolkit4Famix3' }
FAMIXAbstractFileAnchor >> gtAddLinksTo: text [
	| associations |
	self correspondingFile ifNil: [ ^ self ].
	associations := OrderedCollection new.
	self correspondingFile entities
		do:
			[ :each | 
			each
				gtLinksForFile: self fileReference
				do: [ :entity :start :stop | stop < start ifFalse: [ associations add: (start to: stop) -> entity ] ] ].
	associations sort: [ :a :b | a key first < b key first or: [ a key first = b key first and: [ a key last > b key last ] ] ].
	associations
		do:
			[ :each | 
			text
				clearAttributes: each key first
				to: each key last
				if: [ :attr | attr class == BrTextHoverStylableAttribute or: [ attr class == BrTextClickAttribute ] ].
			text
				attributes:
					{(BrTextHoverStylableAttribute new)
							beNotOverwritableByStyler;
							attribute: (BlTextUnderlineAttribute new color: BrGlamorousColors linkColor).
						(BrTextClickAttribute new)
							beNotOverwritableByStyler;
							action: [ :aText :aTarget :aTextEditor :anEvent | aTarget phlow selectObject: each value ]}
				from: each key first
				to: each key last ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXAbstractFileAnchor >> gtCompleteSourceFor: aView [
	<gtView>
	| view |
	self completeText isEmpty ifTrue: [ ^ aView empty ].
	view := aView textEditor
			title: 'Complete source';
			priority: 5;
			aptitude: BrGlamorousCodeEditorAptitude;
			text: [ self gtText ];
			scrollAndHighlight: [ GtPhlowTextHighlight from: self startPos to: self endPos ].
	element
		ifNotNil: [ element gtStyler ifNotNil: [ :styler | view styler: styler ] ].
	^ view
]

{ #category : #'*GToolkit4Famix3' }
FAMIXAbstractFileAnchor >> gtText [
	| text |
	text := self completeText asRopedText.
	(text from: self startPos to: self endPos)
		attributes:
			{(BlTextHighlightAttribute new
				beNotOverwritableByStyler;
				paint: (BrGlamorousColors neutralBackgroundColor))}.
				
	self flag: #TODO.
	"computing links is slow and should be refactored to be a dedicated styler"
	"self gtAddLinksTo: text."
	^ text
]
