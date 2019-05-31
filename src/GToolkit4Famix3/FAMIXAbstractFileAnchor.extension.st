Extension { #name : #FAMIXAbstractFileAnchor }

{ #category : #'*GToolkit4Famix3' }
FAMIXAbstractFileAnchor >> gtAddLinksTo: text [
	| associations |
	self correspondingFile ifNil: [ ^ self ].
	associations := self correspondingFile entities
		select: [ :each | 
			each isAssociation
				and: [ each sourceAnchor notNil and: [ each sourceAnchor isFile ] ] ].
	associations
		sort: [ :a :b | 
			a sourceAnchor startPos < b sourceAnchor startPos
				or: [ a sourceAnchor startPos = b sourceAnchor startPos
						and: [ a sourceAnchor endPos > b sourceAnchor endPos ] ] ].
	associations
		do: [ :each | 
			(text from: each sourceAnchor startPos to: each sourceAnchor endPos)
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
								[ :aText :aTarget :aTextEditor :anEvent | aTarget phlow selectObject: each to ])} ]
]
