Extension { #name : #FAMIXAbstractFileAnchor }

{ #category : #'*GToolkit4Famix3' }
FAMIXAbstractFileAnchor >> gtAddLinksTo: text [
	| associations |
	self correspondingFile ifNil: [ ^ self ].
	associations := OrderedCollection new.
	self correspondingFile entities
		do: [ :each | 
			(each sourceAnchor notNil and: [ each sourceAnchor isFile ])
				ifTrue: [ each isAssociation
						ifTrue: [ associations add: each sourceAnchor -> each to ]
						ifFalse: [ ((each isKindOf: FAMIXStructuralEntity)
								and: [ each declaredType notNil ])
								ifTrue: [ associations add: each sourceAnchor -> each declaredType ] ] ] ].
	associations
		sort: [ :a :b | 
			a key startPos < b key startPos
				or:
					[ a key startPos = b key startPos and: [ a key endPos > b key endPos ] ] ].
	associations
		do: [ :each | 
			(text from: each key startPos to: each key endPos)
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
