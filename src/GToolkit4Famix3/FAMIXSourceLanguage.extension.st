Extension { #name : #FAMIXSourceLanguage }

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceLanguage >> addExpanderFor: association in: text [
	| to pos |
	(association isKindOf: FAMIXAssociation) ifFalse: [ ^ self ].
	to := association expandTo.
	((to isKindOf: Collection) and: [ to size = 1 ]) ifTrue: [ to := to anyOne ].
	(to isNil or: [ association sourceAnchor isNil ]) ifTrue: [ ^ self ].
	pos := association gtInspectButtonPosition.
	(text from: pos to: pos)
		attribute: (BrGlamorousTriangleExpanderTextAttribute new
				attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
						beAppend;
						stencil: [ | pane view |
							pane := BrVerticalPane new
									height: 300;
									aptitude: BrShadowAptitude
											+ (BrGlamorousWithVerticalResizerAptitude new
													beBottom;
													yourself);
									background: Color white;
									margin: (BlInsets all: 10);
									constraintsDo: [ :c | 
										c textFlow pushLine.
										c horizontal matchParent ].
							view := to gtFamixExpanderView.
							((to isKindOf: FAMIXSourcedEntity) and: [ to containerFiles notEmpty ])
								ifTrue: [ pane
										addChild: (BrButton new
												aptitude: BrGlamorousButtonRectangularAptitude
														+ (BrGlamorousButtonLabelAptitude new selectedColor: Color black);
												action: [ pane phlow spawnObject: to containerFiles first ];
												alignCenterLeft;
												label: to containerFiles first fullName) ].
							pane
								addChild: (view asElement
										constraintsDo: [ :c | 
											c horizontal matchParent.
											c vertical matchParent ]) ] ])
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceLanguage >> addInspectButtonFor: anEntity in: text [
	| pos |
	((anEntity isKindOf: FAMIXSourcedEntity) and: [ anEntity sourceAnchor notNil ])
		ifFalse: [ ^ self ].
	pos := anEntity gtInspectButtonPosition.
	(text from: pos to: pos)
		attribute: (GtButtonAttribute new
				beAppend;
				stencil: [ | button |
					button := BrButton new.
					button
						aptitude: (BrLazyStyleCommonAptitude new
								default: [ :aStyle | aStyle background: BrGlamorousColors defaultButtonBorderColor ];
								hovered: [ :aStyle | aStyle background: BrGlamorousColors hoveredButtonBorderColor ]);
						size: 8 @ 8;
						geometry: BlEllipseGeometry new;
						margin: (BlInsets left: 2 right: 2);
						action: [ :aButtonElement :aButtonModel :anEvent | button phlow spawnObject: anEntity ];
						yourself ])
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceLanguage >> addInspectButtonWithHighlightFor: anEntity in: text [
	| pos hoverAttribute interval existingHighlights |
	((anEntity isKindOf: FAMIXSourcedEntity) and: [ anEntity sourceAnchor notNil ])
		ifFalse: [ ^ self ].
	interval := anEntity sourceAnchor startPos to: anEntity sourceAnchor endPos.
	hoverAttribute := BlTextHighlightAttribute
			paint: BrGlamorousColors textHighlightColor.
	pos := anEntity gtInspectButtonPosition.
	(text from: pos to: pos)
		attribute: (GtButtonAttribute new
				beAppend;
				stencil: [ | button |
					button := BrButton new.
					button
						aptitude: (BrLazyStyleCommonAptitude new
								default: [ :aStyle | aStyle background: BrGlamorousColors defaultButtonBorderColor ];
								hovered: [ :aStyle | aStyle background: BrGlamorousColors hoveredButtonBorderColor ]);
						size: 8 @ 8;
						geometry: BlEllipseGeometry new;
						margin: (BlInsets left: 2 right: 2);
						action: [ :aButtonElement :aButtonModel :anEvent | button phlow spawnObject: anEntity ];
						when: BlMouseEnterEvent
							do: [ :anEvent | 
								button
									allParentsDetect: [ :each | each isKindOf: BrEditorElement ]
									ifFound: [ :anEditorElement | 
										interval last <= anEditorElement text size
											ifTrue: [ existingHighlights := (interval first to: interval last)
														collect: [ :each | 
															(anEditorElement text attributesAt: each)
																detect: [ :attr | attr isKindOf: BlTextHighlightAttribute ]
																ifNone: [  ] ] ].
										(anEditorElement text
											from: (interval first min: anEditorElement text size)
											to: (interval last min: anEditorElement text size))
											attribute: hoverAttribute ]
									ifNone: [  ] ];
						when: BlMouseLeaveEvent
							do: [ :anEvent | 
								button
									allParentsDetect: [ :each | each isKindOf: BrEditorElement ]
									ifFound: [ :anEditorElement | 
										anEditorElement text clearAttributes: [ :each | each == hoverAttribute ].
										(existingHighlights notNil
											and: [ interval last <= anEditorElement text size ])
											ifTrue: [ (interval first to: interval last)
													with: existingHighlights
													do: [ :i :attr | 
														attr
															ifNotNil: [ anEditorElement text
																	attribute: attr
																	from: i
																	to: i ] ] ].
										existingHighlights := nil ]
									ifNone: [  ] ];
						yourself ])
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceLanguage >> gtASTNodeFor: aString at: anInterval [
	^ self gtParserClass
		ifNotNil: [ :class | (class parseWithErrors: aString) nodeForInterval: anInterval ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceLanguage >> gtParserClass [
	^ nil
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceLanguage >> gtStyler [
	^ self gtParserClass ifNotNil: [ :class | class gtStyler ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceLanguage >> gtStylerFor: anEntity [
	^ self gtStyler
]
