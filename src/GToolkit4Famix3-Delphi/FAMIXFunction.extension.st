Extension { #name : #FAMIXFunction }

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXFunction >> lookupFunctionNamed: aString [ 
	^ self functions 
		detect: [ :function | function name asLowercase = aString asLowercase ]
		ifNone: [ self container lookupFunctionNamed: aString ]
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXFunction >> lookupTypeNamed: aString [ 
	^ self container lookupTypeNamed: aString
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXFunction >> lookupUnitNamed: aString [ 
	^ self container lookupUnitNamed: aString
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXFunction >> lookupVariableNamed: aString [
	^ (self localVariables, self parameters)
		detect: [ :variable | variable name asLowercase = aString asLowercase ]
		ifNone: [ self container lookupVariableNamed: aString ]
]
