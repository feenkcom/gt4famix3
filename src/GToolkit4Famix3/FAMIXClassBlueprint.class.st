Class {
	#name : #FAMIXClassBlueprint,
	#superclass : #BrStencil,
	#instVars : [
		'types',
		'methodsToElements',
		'attributesToElements',
		'classesToElements'
	],
	#category : #GToolkit4Famix3
}

{ #category : #rendering }
FAMIXClassBlueprint >> colorForMethod: aMethod [
	
	aMethod isPureAccessor ifTrue: [ ^ Color orange alpha: 0.5].
	
	aMethod isSetter ifTrue: [ ^ Color red alpha: 0.5].

	aMethod isGetter ifTrue: [ ^ Color orange alpha: 0.5].

	aMethod isAbstract ifTrue: [ ^ Color cyan alpha: 0.5].

	aMethod isOverriding ifTrue: [ ^ Color brown alpha: 0.5].

	aMethod isConstant ifTrue: [ ^ Color magenta alpha: 0.5 ].
	
	^ Color lightGray alpha: 0.2
]

{ #category : #rendering }
FAMIXClassBlueprint >> create [
	| container |
	container := BlElement new 
		constraintsDo: [:c | 
			c horizontal fitContent.
			c vertical fitContent ];
		layout: (GtGraphTreeLayout new verticalGap: 50; horizontalGap: 20).
	classesToElements := IdentityDictionary new. 
	types do: [:class |
		| classElement |
		classElement := self createType: class.
		classesToElements at: class put: classElement.
		container addChild: classElement
	].
	classesToElements associationsDo: [:assoc |
		assoc key directSubclasses do: [:subclass |
			classesToElements at: subclass ifPresent: [:subclassElement |
				assoc value graph connectTo: subclassElement.
				container addChild: (
					BlLineElement new 
						constraintsDo: [:c | c ignoreByLayout];
						border: (BlBorder paint: (Color gray alpha: 0.3) width: 2);
							zIndex: -2;
						fromAnchor: (BlElementBottomCenterAnchor referenceElement: assoc value relatedTo: subclassElement);
							toAnchor: (BlElementTopCenterAnchor referenceElement: subclassElement relatedTo: assoc value);
						fromHead: (BlArrowheadSimpleArrow new border: (BlBorder builder paint: (Color gray darker alpha: 0.3); width: 5; build))
						) ]]].
	methodsToElements associationsDo: [ :assoc |
		assoc key queryAllOutgoingInvocations opposites withoutSelfLoops do: [ :anInvokedMethod |
			methodsToElements at: anInvokedMethod ifPresent: [ :invokedMethodElement |
				| lineElement |
				lineElement := BlParabollaArcElement new
					border: (BlBorder paint: (Color red darker alpha: 0.3) width: 1);
					zIndex: -1;
					curvatureFraction: 0.1;
					fromAnchor: (BlElementCenterRightAnchor referenceElement: assoc value relatedTo: invokedMethodElement);
					toAnchor: (BlElementCenterLeftAnchor referenceElement: invokedMethodElement relatedTo: assoc value);
					toHead: (BlArrowheadSimpleArrow new border: (BlBorder builder paint: (Color red darker alpha: 0.3); width: 1; build)).
				lineElement constraints ignoreByLayout.
				container addChild: lineElement ] ].
		assoc key accessedAttributes do: [ :anAccessedAttribute |
			attributesToElements at: anAccessedAttribute ifPresent: [ :accessedAttributeElement |
				| lineElement |
				lineElement := BlParabollaArcElement new
					border: (BlBorder paint: (Color blue alpha: 0.2) width: 1);
					zIndex: -1;
					curvatureFraction: 0.1;
					fromAnchor: (BlElementCenterRightAnchor referenceElement: assoc value relatedTo: accessedAttributeElement);
					toAnchor: (BlElementCenterLeftAnchor referenceElement: accessedAttributeElement relatedTo: assoc value);
					toHead: (BlArrowheadSimpleArrow new border: (BlBorder builder paint: (Color blue alpha: 0.2); width: 1; build)).
				lineElement constraints ignoreByLayout.
				container addChild: lineElement ] ] ].
	^ container
]

{ #category : #rendering }
FAMIXClassBlueprint >> createLayerForAttributes: aCollection [
	| attributesContainer layerLabel |
	attributesContainer := BlElement new 
		padding: (BlInsets top: 5 left: 5 bottom: 5 right: 5);
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal fitContent.
			c linear horizontal alignCenter ];
		layout: (BlLinearLayout vertical cellSpacing: 5).
	layerLabel := BlTextElement new
		text: ('Attributes' asRopedText
				glamorousRegularFont;
				fontSize: 8;
				foreground: Color gray);
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal fitContent.
			c linear horizontal alignCenter ].
	aCollection do: [ :anAttribute | 
		| attributeElement |
		attributeElement := BlElement new
			size: 5@5;
			border: (BlBorder paint: Color blue);
			background: (Color blue alpha: 0.5);
			when: BlClickEvent do: [:e | e target phlow spawnObject: anAttribute. e consumed: true].
		attributeElement graph model: anAttribute.
		attributesToElements at: anAttribute put: attributeElement.
		attributesContainer addChild: attributeElement ].
	^ BlElement new
		padding: (BlInsets top: 10 left: 20 bottom: 10 right: 20);
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal fitContent ];
		layout: BlLinearLayout vertical;
		addChild: layerLabel;
		addChild: attributesContainer;
		when: BlClickEvent do: [:e | e target phlow spawnObject: aCollection. e consumed: true ].
]

{ #category : #rendering }
FAMIXClassBlueprint >> createLayerForMethods: aCollection named: aString [
	| methodsContainer layerLabel layerMethodsToElements |
	layerMethodsToElements := IdentityDictionary new.
	methodsContainer := BlElement new 
		padding: (BlInsets top: 10 left: 5 bottom: 5 right: 5);
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal fitContent.
			c linear horizontal alignCenter ];
		layout: (GtGraphHorizontalTreeLayout new layered horizontalGap: 30).
	layerLabel := BlTextElement new
		text: (aString asRopedText
				glamorousRegularFont;
				fontSize: 8;
				foreground: Color gray);
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal fitContent.
			c linear horizontal alignCenter ].
	aCollection do: [ :aMethod | 
		| methodElement |
		methodElement := BlElement new
			size: (aMethod numberOfOutgoingInvocations max: 5)@((aMethod numberOfLinesOfCode / 5) max: 5);
			border: (BlBorder paint: Color black);
			background: (self colorForMethod: aMethod);
			when: BlClickEvent do: [:e | e target phlow spawnObject: aMethod. e consumed: true].
		methodElement graph model: aMethod.
		layerMethodsToElements at: aMethod put: methodElement.
		methodsToElements at: aMethod put: methodElement.
		methodsContainer addChild: methodElement ].
	aCollection do: [ :aMethod |
		| methodElement |
		methodElement := layerMethodsToElements at: aMethod.
		aMethod invokedMethods do: [ :anInvokedMethod |
			layerMethodsToElements at: anInvokedMethod ifPresent: [ :anInvokedMethodElement |
				methodElement graph connectTo: anInvokedMethodElement ] ] ]. 
	^ BlElement new
		padding: (BlInsets top: 10 left: 20 bottom: 10 right: 20);
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal fitContent ];
		layout: BlLinearLayout vertical;
		addChild: layerLabel;
		addChild: methodsContainer;
		when: BlClickEvent do: [:e | e target phlow spawnObject: aCollection. e consumed: true ].
]

{ #category : #rendering }
FAMIXClassBlueprint >> createType: aType [
	| childrenContainer classLabel classElement |
	childrenContainer := BlElement new
		border: (BlBorder paint: Color lightGray width: 2);
		layout: (BlLinearLayout horizontal cellSpacing: 0);
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal fitContent.
			c linear horizontal alignCenter ].
	classLabel := BlTextElement new
		text: (aType name asRopedText
				glamorousRegularFont;
				fontSize: 12;
				foreground: Color black);
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal fitContent.
			c linear horizontal alignCenter ].
	classElement := BlElement new
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal fitContent ];
		layout: (BlLinearLayout vertical cellSpacing: 2);
		when: BlClickEvent do: [ :e | e target phlow spawnObject: aType ];
		addChild: classLabel;
		addChild: childrenContainer.
	classElement graph model: aType.
	childrenContainer addChild: (self createLayerForMethods: aType constructors named: 'Initializers').
	childrenContainer addChild: (self createLayerForMethods: aType interfaceMethods named: 'Interface').
	childrenContainer addChild: (self createLayerForMethods: aType implementationMethods named: 'Implementation').
	childrenContainer addChild: (self createLayerForMethods: aType accessorMethods named: 'Accessors').
	childrenContainer addChild: (self createLayerForAttributes: aType attributes).
	^ classElement
]

{ #category : #initialization }
FAMIXClassBlueprint >> initialize [
	super initialize.
	methodsToElements := IdentityDictionary new.
	attributesToElements := IdentityDictionary new.
	classesToElements := IdentityDictionary new.
	types := OrderedCollection new
]

{ #category : #accessing }
FAMIXClassBlueprint >> type: aType [
	types := { aType }
]

{ #category : #accessing }
FAMIXClassBlueprint >> types: aCollection [
	types := aCollection
]
