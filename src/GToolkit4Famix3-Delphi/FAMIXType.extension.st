Extension { #name : #FAMIXType }

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXType >> delphiFormObjects [
	^ self attributes flatCollect: [ :each | each delphiFormObjects ]
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXType >> isTOraQuery [
	^ self name = 'TOraQuery'
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXType >> isTOraSQL [
	^ self name = 'TOraSQL'
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXType >> isTOraStoredProc [
	^ self name = 'TOraStoredProc'
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXType >> lookup: aBlock named: aString [
	| lookup |
	^ (aBlock value: self)
		detect: [ :each | each name asLowercase = aString asLowercase ]
		ifNone: [ 
			self directSuperclasses do: [ :superclass | 
				lookup := superclass lookup: aBlock named: aString.
				lookup ifNotNil: [ ^ lookup ] ].
			nil ]
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXType >> lookupTypeNamed: aString [ 
	self withSuperclassHierarchy do: [ :each | each name asLowercase = aString asLowercase ifTrue: [ ^ each ] ].
	^ self container lookupTypeNamed: aString
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXType >> lookupVariableNamed: aString [
	^ (self 
		lookup: [:class | class attributes ] 
		named: aString)
			ifNil: [ self container lookupVariableNamed: aString ]
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXType >> mooseFinderDelphiFormObjectsIn: composite [
	<moosePresentationOrder: 50>
	| shape element |
	composite roassal2
		title: 'Form objects';
		painting: [ :view |
			self delphiFormObjects do: [ :obj |
				shape := (RTBitmap new form: (obj icon" asAlphaImageMorph alpha: 0.5) cachedForm")).
				element := shape elementOn: obj.
				view add: element.
				element translateTo: (obj leftPropertyValue @ obj topPropertyValue) ].
			 view @ RTDraggableView ];
		when: [ self delphiFormObjects notEmpty ]
]
