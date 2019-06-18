Class {
	#name : #FKDelphiThreeDependingUnitsTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #hooks }
FKDelphiThreeDependingUnitsTest >> files [
	^ { #unitAPas . #unitBPas . #unitCPas }
]

{ #category : #hooks }
FKDelphiThreeDependingUnitsTest >> pasFiles [
	^ { #unitA . #unitB . #unitC }
]

{ #category : #testing }
FKDelphiThreeDependingUnitsTest >> testUnitA [
	self assert: (model allDelphiUnits entityNamed: 'UnitA') outgoingUsesAssociations size equals: 3.
	self assert: ((model allDelphiUnits entityNamed: 'UnitA') outgoingUsesAssociations select: #isInterface) size equals: 2.
	
]

{ #category : #testing }
FKDelphiThreeDependingUnitsTest >> testUnitB [
	self assert: (model allDelphiUnits entityNamed: 'UnitB') outgoingUsesAssociations size equals: 1.
	self assert: (model allDelphiUnits entityNamed: 'UnitB') outgoingUsesAssociations anyOne usedUnit notNil.
	self assert: (model allDelphiUnits entityNamed: 'UnitB') outgoingUsesAssociations anyOne usedUnit = (model allDelphiUnits entityNamed: 'UnitC').
]

{ #category : #testing }
FKDelphiThreeDependingUnitsTest >> testUnitC [
	self assert: (model allDelphiUnits entityNamed: 'UnitC') outgoingUsesAssociations size equals: 0
]

{ #category : #testing }
FKDelphiThreeDependingUnitsTest >> testUnits [
	self assert: model allDelphiUnits size equals: 4.
	self assert: (model allDelphiUnits select: #isStub) size equals: 1
]

{ #category : #hooks }
FKDelphiThreeDependingUnitsTest >> unitA [
	^ 'unit UnitA;

interface

uses UnitB, UnitC;

implementation

uses UnitD;

end.
'
]

{ #category : #hooks }
FKDelphiThreeDependingUnitsTest >> unitAPas [
	^ 'unit UnitA;

interface

uses UnitB, UnitC;

implementation

uses UnitD;

end.
'
]

{ #category : #hooks }
FKDelphiThreeDependingUnitsTest >> unitB [
	^ 'unit UnitB;

interface

uses UnitC;

end.
'
]

{ #category : #hooks }
FKDelphiThreeDependingUnitsTest >> unitBPas [
	^ 'unit UnitB;

interface

uses UnitC;

end.
'
]

{ #category : #hooks }
FKDelphiThreeDependingUnitsTest >> unitC [
	^ 'unit UnitC;

end.
'
]

{ #category : #hooks }
FKDelphiThreeDependingUnitsTest >> unitCPas [
	^ 'unit UnitC;

end.
'
]
