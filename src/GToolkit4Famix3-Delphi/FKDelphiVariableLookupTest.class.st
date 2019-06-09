Class {
	#name : #FKDelphiVariableLookupTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #hooks }
FKDelphiVariableLookupTest >> files [
	^ { #unitAPas . #unitBPas }
]

{ #category : #testing }
FKDelphiVariableLookupTest >> testUnitA [
	| unitA |
	unitA := (model allDelphiUnits entityNamed: 'UnitA').
	self assert: (unitA lookupVariableNamed: 'VariableA') parentScope equals: unitA.
	self assert: (unitA lookupVariableNamed: 'VariableB') parentScope equals: unitA.
	self assert: (unitA lookupVariableNamed: 'VariableX') isNil.
	self assert: (unitA lookupVariableNamed: 'ConstantA') parentScope equals: unitA.
	
]

{ #category : #tests }
FKDelphiVariableLookupTest >> testUnitAWithQualifiedNames [
	| unitA procA methodA |
	unitA := (model allDelphiUnits entityNamed: 'UnitA').
	self assert: (unitA lookupVariableWithNames: {'VariableA'}) parentScope equals: unitA.
	procA := unitA functions anyOne.
	self assert: (procA lookupVariableWithNames: {'VariableA' . 'AttributeA'}) notNil.
	methodA := unitA types anyOne methods anyOne.
	self assert: (methodA lookupVariableWithNames: {'VariableA' . 'AttributeA'}) notNil.
	self assert: (methodA lookupVariableWithNames: {'self' . 'AttributeA'}) notNil.
	
]

{ #category : #hooks }
FKDelphiVariableLookupTest >> unitAPas [
	^ 'unit UnitA;

interface
	uses UnitB;	
	procedure ProcA();
	type TypeA = class(TypeB)
		AttributeA: String;
		procedure ProcA();
	end;

	var
		VariableA: TypeA;
	
	const
		ConstantA = 42;

implementation
	var
		VariableB: TypeA;

end.
'
]

{ #category : #hooks }
FKDelphiVariableLookupTest >> unitBPas [
	^ 'unit UnitB;

interface
	type TypeB = class
		AttributeB: String;
		procedure ProcB();
	end;

	var
		VariableB: TypeA;
	
	const
		ConstantB = 42;

implementation
	var
		VariableB: TypeA;

end.
'
]
