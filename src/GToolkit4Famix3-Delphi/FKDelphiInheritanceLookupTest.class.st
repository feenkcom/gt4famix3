Class {
	#name : #FKDelphiInheritanceLookupTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #hooks }
FKDelphiInheritanceLookupTest >> files [
	^ { #unitAPas . #unitBPas . #unitCPas }
]

{ #category : #testing }
FKDelphiInheritanceLookupTest >> testUnitA [
	self assert: (model entityNamed: 'UnitA::TypeA') superInheritances size equals: 2.
	self assert: ((model entityNamed: 'UnitA::TypeA') directSuperclasses includes: (model entityNamed: 'UnitB::TypeB')).
	self assert: ((model entityNamed: 'UnitA::TypeA') directSuperclasses includes: (model entityNamed: 'UnitC::TypeC'))
]

{ #category : #testing }
FKDelphiInheritanceLookupTest >> testUnitC [
	self assert: (model entityNamed: 'UnitC::TypeC') superInheritances size equals: 1.
	self assert: (model entityNamed: 'UnitC::TypeC') superInheritances anyOne superclass notNil
]

{ #category : #testing }
FKDelphiInheritanceLookupTest >> testUnits [
	self assert: model allDelphiUnits size equals: 5
]

{ #category : #hooks }
FKDelphiInheritanceLookupTest >> unitAPas [
	^ 'unit UnitA;

interface
	uses UnitB, UnitC;	
	type TypeA = class(TypeB, TypeC)
	end;

end.
'
]

{ #category : #hooks }
FKDelphiInheritanceLookupTest >> unitBPas [
	^ 'unit UnitB;

interface
	uses UnitC;
	type TypeA = class(TypeB)
	end;
	type TypeB = class(TypeC)
	end;
end.
'
]

{ #category : #hooks }
FKDelphiInheritanceLookupTest >> unitCPas [
	^ 'unit UnitC;
interface
	uses UnitD;
	type TypeA = class(TypeA)
	end;
	type TypeB = class(TypeC)
	end;
	type TypeC = class(TypeD)
	end;
end.
'
]
