Class {
	#name : #FAMIXClassBlueprint,
	#superclass : #BrStencil,
	#instVars : [
		'type',
		'methodsToElements'
	],
	#category : #GToolkit4Famix3
}

{ #category : #rendering }
FAMIXClassBlueprint >> create [
	| childrenContainer classLabel classElement |
	childrenContainer := BlElement new
		border: (BlBorder paint: Color lightGray width: 2);
		padding: (BlInsets top: 10 left: 30 bottom: 10 right: 30);
		layout: (BlLinearLayout horizontal cellSpacing: 0);
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal fitContent.
			c linear horizontal alignCenter ].
	classLabel := BlTextElement new
		text:
			(self type name asRopedText
				glamorousRegularFont;
				fontSize: 10;
				foreground: Color black);
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal fitContent.
			c linear horizontal alignCenter ].
	classElement := BlElement new
		padding: (BlInsets all: 5);
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal fitContent ];
		layout: (BlLinearLayout vertical cellSpacing: 2);
		addChild: classLabel;
		addChild: childrenContainer.
	childrenContainer addChild: (self methods: type constructors inLayer: 'Initializers').
	childrenContainer addChild: (self methods: type interfaceMethods inLayer: 'Interface').
	childrenContainer addChild: (self methods: type implementationMethods inLayer: 'Implementation').
	childrenContainer addChild: (self methods: type accessorMethods inLayer: 'Accessors').
	methodsToElements associationsDo: [ :assoc |
		assoc key queryAllOutgoingInvocations opposites withoutSelfLoops do: [ :anInvokedMethod |
			methodsToElements at: anInvokedMethod ifPresent: [ :invokedMethodElement |
				| lineElement |
				lineElement := BlParabollaArcElement new
					border: (BlBorder paint: (Color gray alpha: 0.3) width: 1);
					zIndex: -1;
					curvatureFraction: 0.1;
					fromAnchor: (BlElementCenterRightAnchor referenceElement: assoc value relatedTo: invokedMethodElement);
					toAnchor: (BlElementCenterLeftAnchor referenceElement: invokedMethodElement relatedTo: assoc value);
					toHead: (BlArrowheadSimpleArrow new border: (BlBorder builder paint: (Color gray alpha: 0.3); width: 1; build)).
				lineElement constraints ignoreByLayout.
				classElement addChild: lineElement ] ] ].
	^ classElement
]

{ #category : #initialization }
FAMIXClassBlueprint >> initialize [
	super initialize.
	methodsToElements := IdentityDictionary new
]

{ #category : #rendering }
FAMIXClassBlueprint >> methods: aCollection inLayer: aString [
	| methodsContainer layerLabel layerMethodsToElements |
	layerMethodsToElements := IdentityDictionary new.
	methodsContainer := BlElement new 
		padding: (BlInsets all: 5);
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal fitContent.
			c linear horizontal alignCenter ];
		layout: GtGraphHorizontalTreeLayout new layered.
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
			size: (aMethod numberOfLinesOfCode max: 5) asPoint;
			border: (BlBorder paint: Color black);
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
		padding: (BlInsets all: 5);
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal fitContent ];
		layout: BlLinearLayout vertical;
		addChild: layerLabel;
		addChild: methodsContainer;
		when: BlClickEvent do: [:e | e target phlow spawnObject: aCollection. e consumed: true ].
]

{ #category : #accessing }
FAMIXClassBlueprint >> type [
	^ type
]

{ #category : #accessing }
FAMIXClassBlueprint >> type: anObject [
	type := anObject
]
