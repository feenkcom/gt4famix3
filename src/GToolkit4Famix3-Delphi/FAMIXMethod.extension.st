Extension { #name : #FAMIXMethod }

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXMethod >> lookupFunctionNamed: aString [ 
	self parentType withSuperclassHierarchy do: [ :each | 
		each methods do: [ :method | 
			method name = aString ifTrue: [ ^ method ] ] ].
	^ self parentType container lookupFunctionNamed: aString
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXMethod >> lookupTypeNamed: aString [ 
	^ self parentType lookupTypeNamed: aString
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXMethod >> lookupUnitNamed: aString [ 
	^ self parentType lookupUnitNamed: aString
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXMethod >> lookupVariableNamed: aString [
	^ (self localVariables, self parameters)
		detect: [ :variable | variable name asLowercase = aString asLowercase ]
		ifNone: [ self parentType lookupVariableNamed: aString ]
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXMethod >> lookupVariableWithNames: aCollectionOfStrings [
	"this is a lookup based on the qualified name"
	aCollectionOfStrings first asLowercase = 'self' ifTrue: [ ^ self parentType lookupVariableWithNames: aCollectionOfStrings allButFirst ].
	^ super lookupVariableWithNames: aCollectionOfStrings
]
