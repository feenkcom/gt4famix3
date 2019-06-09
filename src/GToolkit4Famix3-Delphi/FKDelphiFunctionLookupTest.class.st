Class {
	#name : #FKDelphiFunctionLookupTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #hooks }
FKDelphiFunctionLookupTest >> files [
	^ { #unitAPas . #unitBPas . #unitCPas }
]

{ #category : #testing }
FKDelphiFunctionLookupTest >> testUnitA [
	| unitA unitB unitC |
	unitA := (model allDelphiUnits entityNamed: 'UnitA').
	unitB := (model allDelphiUnits entityNamed: 'UnitB').
	unitC := (model allDelphiUnits entityNamed: 'UnitC').
	self assert: (unitA lookupFunctionNamed: 'ProcA') container equals: unitA.
	self assert: (unitA lookupFunctionNamed: 'ProcB') container equals: unitB.
	self assert: (unitA lookupFunctionNamed: 'ProcC') container equals: unitC.
	self assert: (unitA lookupFunctionNamed: 'ProcX') isNil.

	self assert: (unitA lookupTypeNamed: 'TypeA') container equals: unitA.
	self assert: (unitA lookupTypeNamed: 'TypeB') container equals: unitB.
	self assert: (unitA lookupTypeNamed: 'TypeC') container equals: unitC	
]

{ #category : #testing }
FKDelphiFunctionLookupTest >> testUnitB [
	| unitB unitC |
	unitB := (model allDelphiUnits entityNamed: 'UnitB').
	unitC := (model allDelphiUnits entityNamed: 'UnitC').
	self assert: (unitB lookupFunctionNamed: 'ProcA') container equals: unitB.
	self assert: (unitB lookupFunctionNamed: 'ProcB') container equals: unitB.
	self assert: (unitB lookupFunctionNamed: 'ProcC') container equals: unitC.
	self assert: (unitB lookupFunctionNamed: 'ProcX') isNil.
]

{ #category : #hooks }
FKDelphiFunctionLookupTest >> unitAPas [
	^ 'unit UnitA;

interface
	uses UnitB, UnitC;	
	procedure ProcA();
	type TypeA = class
	end;

end.
'
]

{ #category : #hooks }
FKDelphiFunctionLookupTest >> unitBPas [
	^ 'unit UnitB;

interface
	uses UnitC;
	procedure ProcA();
	procedure ProcB();
	type TypeA = class
	end;
	type TypeB = class
	end;
end.
'
]

{ #category : #hooks }
FKDelphiFunctionLookupTest >> unitCPas [
	^ 'unit UnitC;
interface
	procedure ProcA();
	procedure ProcB();
	procedure ProcC();
	type TypeA = class
	end;
	type TypeB = class
	end;
	type TypeC = class
	end;
end.
'
]
