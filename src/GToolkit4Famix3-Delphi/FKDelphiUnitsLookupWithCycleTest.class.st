Class {
	#name : #FKDelphiUnitsLookupWithCycleTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #hooks }
FKDelphiUnitsLookupWithCycleTest >> files [
	^ { #unitAPas . #unitBPas . #unitCPas }
]

{ #category : #hooks }
FKDelphiUnitsLookupWithCycleTest >> pasFiles [
	^ { #unitA . #unitB . #unitC }
]

{ #category : #testing }
FKDelphiUnitsLookupWithCycleTest >> testUnitA [
	| unitA unitB unitC |
	unitA := (model allDelphiUnits entityNamed: 'UnitA').
	unitB := (model allDelphiUnits entityNamed: 'UnitB').
	unitC := (model allDelphiUnits entityNamed: 'UnitC').
	self assert: (unitA lookupFunctionNamed: 'ProcA') container equals: unitA.
	self assert: (unitA lookupFunctionNamed: 'ProcB') container equals: unitB.
	self assert: (unitA lookupFunctionNamed: 'ProcC') container equals: unitC.
	self assert: (unitA lookupFunctionNamed: 'ProcX') isNil.
]

{ #category : #hooks }
FKDelphiUnitsLookupWithCycleTest >> unitA [
	^ 'unit UnitA;

interface
	uses UnitB, UnitC;	
	procedure ProcA();

end.
'
]

{ #category : #hooks }
FKDelphiUnitsLookupWithCycleTest >> unitAPas [
	^ 'unit UnitA;

interface
	uses UnitB, UnitC;	
	procedure ProcA();

end.
'
]

{ #category : #hooks }
FKDelphiUnitsLookupWithCycleTest >> unitB [
	^ 'unit UnitB;

interface
	uses UnitA,UnitC;
	procedure ProcA();
	procedure ProcB();

end.
'
]

{ #category : #hooks }
FKDelphiUnitsLookupWithCycleTest >> unitBPas [
	^ 'unit UnitB;

interface
	uses UnitA,UnitC;
	procedure ProcA();
	procedure ProcB();

end.
'
]

{ #category : #hooks }
FKDelphiUnitsLookupWithCycleTest >> unitC [
	^ 'unit UnitC;
interface
	uses UnitA,UnitB;
	procedure ProcA();
	procedure ProcB();
	procedure ProcC();

end.
'
]

{ #category : #hooks }
FKDelphiUnitsLookupWithCycleTest >> unitCPas [
	^ 'unit UnitC;
interface
	uses UnitA,UnitB;
	procedure ProcA();
	procedure ProcB();
	procedure ProcC();

end.
'
]
