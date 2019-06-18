Extension { #name : #FAMIXContainerEntity }

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXContainerEntity >> lookupFunctionNamed: aString [
	^ self subclassResponsibility
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXContainerEntity >> lookupTypeNamed: aString [
	^ self subclassResponsibility
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXContainerEntity >> lookupUnitNamed: aString [
	^ self subclassResponsibility
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXContainerEntity >> lookupVariableNamed: aString [
	^ self subclassResponsibility
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FAMIXContainerEntity >> lookupVariableWithNames: aCollectionOfStrings [
	"this is a lookup based on the qualified name"
	self subclassResponsibility
]
