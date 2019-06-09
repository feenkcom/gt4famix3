Extension { #name : #FAMIXStructuralEntity }

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXStructuralEntity >> delphiFormObjects [
	<MSEProperty: #delphiFormObjects type: #FKDelphiFormObject opposite: #targetEntity>
	^ self privateState 
		attributeAt: #delphiFormObjects 
		ifAbsentPut: [ FMMultivalueLink on: self opposite: #targetEntity: ]
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXStructuralEntity >> delphiFormObjects: aCollection [
	self delphiFormObjects value: aCollection
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXStructuralEntity >> hasDelphiFormObjects [
	^ self delphiFormObjects notEmpty
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXStructuralEntity >> isTOraQuery [
	^ self declaredType notNil and: [ self declaredType isTOraQuery ]
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXStructuralEntity >> isTOraSQL [
	^ self declaredType notNil and: [ self declaredType isTOraSQL ]
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXStructuralEntity >> isTOraStoredProc [
	^ self declaredType notNil and: [ self declaredType isTOraStoredProc ]
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXStructuralEntity >> lookupVariableNamed: aString [ 
	^ self declaredType lookupVariableNamed: aString 
]
