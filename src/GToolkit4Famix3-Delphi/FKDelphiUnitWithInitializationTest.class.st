Class {
	#name : #FKDelphiUnitWithInitializationTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #testing }
FKDelphiUnitWithInitializationTest >> testUnit [
	self assert: model allDelphiUnits anyOne functions size equals: 2
]

{ #category : #hooks }
FKDelphiUnitWithInitializationTest >> unitPas [
	^ 'unit Unit;

Initialization

Proc(43);

Finalization

Proc(41)


end.
'
]
