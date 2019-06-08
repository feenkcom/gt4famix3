Extension { #name : #FAMIXType }

{ #category : #'*GToolkit4Famix3' }
FAMIXType >> gtAttributesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Attributes';
		priority: 15;
		items: [ self attributes ];		
		column: 'Icon' translated do: [ :column | 
			column
				item: [ :each | each gtIcon ];
				rowStencil: [ :eachIcon | eachIcon asElement margin: (BlInsets left: 5 right: 5) ];
				noResize ];
		column: 'Name' translated format: [ :each | each gtDisplayString ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXType >> gtMethodsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Methods';
		priority: 10;
		items: [ self methods sorted: [:a :b | a signature < b signature]];
		column: 'Icon' translated do: [ :column | 
			column
				item: [ :each | each gtIcon ];
				rowStencil: [ :eachIcon | eachIcon asElement margin: (BlInsets left: 5 right: 5) ];
				noResize ];
		column: 'Name' translated format: [ :each | each signature ]
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
