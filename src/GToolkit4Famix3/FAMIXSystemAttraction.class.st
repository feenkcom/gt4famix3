"
This class encapsulates the logic of the system attraction view. It is applicable to a set of famix types.
"
Class {
	#name : #FAMIXSystemAttraction,
	#superclass : #Object,
	#instVars : [
		'classStrongColor',
		'classPaleColor',
		'methodStrongColor',
		'methodPaleColor',
		'attributeStrongColor',
		'attributePaleColor'
	],
	#category : #GToolkit4Famix3
}

{ #category : #'initialize-release' }
FAMIXSystemAttraction >> initialize [ 
	classStrongColor := Color black.
	classPaleColor := Color r: 0.7 g: 0.7 b: 0.7.	

	methodStrongColor := Color r: 1.0 g: 0.3 b: 0.3.
	methodPaleColor := Color r: 1.0 g: 0.7 b: 0.7.
	
	attributeStrongColor := Color r: 0.3 g: 0.3 b: 1.0.
	attributePaleColor := Color r: 0.7 g: 0.7 b: 1.0.
]

{ #category : #rendering }
FAMIXSystemAttraction >> view: classes highlighting: strongClasses on: view [
	| methods attributes |

	methods := classes flatCollect: #methods.
	attributes := classes flatCollect: #attributes.

	view nodes
		ellipse: [ :each :ellipse | 
			ellipse
				border: BlBorder empty;
				size: 10@10;
				background: ((strongClasses includes: each) 
					ifTrue: [ classStrongColor ]
					ifFalse: [ classPaleColor ]) ];
		with: classes.
	view nodes
		ellipse: [ :each :ellipse | 
			ellipse
				border: BlBorder empty;
				size: 6@6;
				background: ((strongClasses includes: each parentType) 
					ifTrue: [ methodStrongColor ]
					ifFalse: [ methodPaleColor ]) ];
		with: methods.	
	view nodes
		ellipse: [ :each :ellipse | 
			ellipse
				border: BlBorder empty;
				size: 6@6;
				background: ((strongClasses includes: each parentType) 
					ifTrue: [ attributeStrongColor ]
					ifFalse: [ attributePaleColor ]) ];
		with: attributes.
	view edges 
		stencil: [ :each | 
			BlLineElement new
				zIndex: -1; 
				border: (BlBorder 
					paint: ((strongClasses includes: each) 
						ifTrue: [ classPaleColor alpha: 0.3 ]
						ifFalse: [ classPaleColor alpha: 0.3]) width: 1) ];
		connect: classes from: #yourself to: #superclass.
	view edges
		stencil: [ :each :fromElement :toElement | 
			BlLineElement new 
				zIndex: -1;
				border: (BlBorder 
					paint: ((strongClasses includes: fromElement graph model) 
						ifTrue: [ classPaleColor alpha: 0.3 ]
						ifFalse: [ classPaleColor alpha: 0.3]) width: 1) ];
		connect: classes from: #yourself toAll: #methods.
	view edges
		stencil: [ :each :fromElement :toElement | 
			BlLineElement new 
				zIndex: -1;
				border: (BlBorder 
					paint: ((strongClasses includes: fromElement graph model) 
						ifTrue: [ classPaleColor alpha: 0.3 ]
						ifFalse: [ classPaleColor alpha: 0.3]) width: 1) ];
		connect: classes from: #yourself toAll: #attributes.
	view edges
		stencil: [ :each | 
			BlLineElement new
				zIndex: -1;
				border: (BlBorder 
					paint: ((strongClasses includes: each parentType) 
						ifTrue: [ methodPaleColor alpha: 0.3 ]
						ifFalse: [ methodPaleColor alpha: 0.3]) width: 1) ];
		connect: methods from: #yourself toAll: #invokedMethods.
	view edges
		stencil: [ :each | 
			BlLineElement new
				zIndex: -1;
				border: (BlBorder 
					paint: ((strongClasses includes: each parentType) 
						ifTrue: [ attributePaleColor alpha: 0.3 ]
						ifFalse: [ attributePaleColor alpha: 0.3]) width: 1) ];
		connect:  attributes fromAll: #accessingMethods to: #yourself.
	view layout force
]
