Extension { #name : #FAMIXType }

{ #category : #'*GToolkit4Famix3' }
FAMIXType >> gtAttributesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Attributes';
		priority: 15;
		items: [ self attributes asOrderedCollection ];
		column: 'Icon' icon: [ :each | each gtIcon ];
		column: 'Name' translated text: [ :each | each name ];
		column: 'Declared type' translated
			text: [ :each | each declaredType gtDisplayString ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXType >> gtBlueprintFor: aView [
	<gtView>
	^ aView explicit
		title: 'Blueprint';
		stencil: [ (FAMIXClassBlueprint new type: self) asElement asPannableElement ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXType >> gtMethodsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Methods';
		priority: 10;
		items: [ self methods sorted: [ :a :b | a signature < b signature ] ];
		column: 'Icon' icon: [ :each | each gtIcon ];
		column: 'Name' translated text: [ :each | each signature ];
		column: 'Declared type' translated
			text: [ :each | each declaredType gtDisplayString ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXType >> paintBlueprintWith: m [
	m nodes 
		stencil: [:method | 
			| childrenContainer label |
			childrenContainer := BlElement new border: (BlBorder paint: Color lightGray width: 2); padding: (BlInsets all: 5).
			childrenContainer graph beChildrenContainer: #default. 
			childrenContainer constraintsDo: [ :c | c vertical fitContent. c horizontal fitContent. c linear horizontal alignCenter ].
			label := BlTextElement new 
				text: (self name asRopedText glamorousRegularFont; fontSize: 10; foreground: Color black); 
				constraintsDo: [ :c | c vertical fitContent. c horizontal fitContent. c linear horizontal alignCenter ].
			BlElement new
				padding: (BlInsets all: 5);
				constraintsDo: [ :c | c vertical fitContent. c horizontal fitContent ];
				layout: (BlLinearLayout vertical cellSpacing: 2);
				addChild: label;
				addChild: childrenContainer ];
		with: { self };
		forEach: [ :class |
			m nodes 
				stencil: [:method | 
					| childrenContainer label |
					childrenContainer := BlElement new padding: (BlInsets all: 5).
					childrenContainer graph beChildrenContainer: #default. 
					childrenContainer constraintsDo: [ :c | c vertical fitContent. c horizontal fitContent. c linear horizontal alignCenter ].
					label := BlTextElement new 
							text: ('Initializers' asRopedText glamorousRegularFont; fontSize: 8; foreground: Color gray); 
							constraintsDo: [ :c | c vertical fitContent. c horizontal fitContent. c linear horizontal alignCenter ].
					BlElement new
						padding: (BlInsets all: 5);
						constraintsDo: [ :c | c vertical fitContent. c horizontal fitContent ];
						layout: BlLinearLayout vertical;
						"addChild: label;"
						addChild: childrenContainer ];
			with: {self constructors};
			forEach: [ :group | 
				m nodes with: group.
				m layout vertical cellSpacing: 5 ].
		m nodes 
			stencil: [:methodGroup | BlElement new padding: (BlInsets all: 10) ];
			with: {self interfaceMethods};
			forEach: [ :group | 
				m nodes with: group.
				m layout vertical cellSpacing: 5 ].
		m nodes 
			stencil: [:methodGroup | BlElement new padding: (BlInsets all: 10) ];
			with: {self implementationMethods};
			forEach: [ :group | 
				m nodes with: group.
				m layout vertical cellSpacing: 5 ].
		m nodes 
			stencil: [:method | BlElement new padding: (BlInsets all: 10) ];
			with: {self accessorMethods};
			forEach: [ :group | 
				m nodes with: group.
				m layout horizontalTree ].
		m nodes 
			stencil: [:attributeGroup | BlElement new padding: (BlInsets all: 10) ];
			with: {self attributes};
			forEach: [ :group | 
				m nodes with: group.
				m layout vertical cellSpacing: 5 ].
		m layout horizontal ].
	m edges 
		fromRightCenter;
		toLeftCenter;
		connect: self methods toAll: [:method | 
			method outgoingInvocations flatCollectAsSet: #candidates ].
	m edges
		fromRightCenter;
		toLeftCenter; 
		connect: self methods toAll: [:method | 
			method accesses collectAsSet: #variable	]
]
