Class {
	#name : #FKDelphiTwoUnitsWithSourceTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #hooks }
FKDelphiTwoUnitsWithSourceTest >> files [
	^ { #unitAPas . #unitBPas }
]

{ #category : #hooks }
FKDelphiTwoUnitsWithSourceTest >> pasFiles [
	^ { #unitA . #unitB }
]

{ #category : #testing }
FKDelphiTwoUnitsWithSourceTest >> testModelHasRootFolder [
	self assert: model rootFolder fileSystem isMemoryFileSystem
]

{ #category : #testing }
FKDelphiTwoUnitsWithSourceTest >> testUnitA [
	self assert: (model allDelphiUnits entityNamed: 'UnitA') sourceAnchor notNil.
	self assert: (model allDelphiUnits entityNamed: 'UnitA') sourceAnchor fileName equals: 'unitA.pas'	.
	self assert: (model allDelphiUnits entityNamed: 'UnitA') sourceAnchor rootFolder equals: model rootFolder.
	self assert: (model allDelphiUnits entityNamed: 'UnitA') sourceText notEmpty
]

{ #category : #testing }
FKDelphiTwoUnitsWithSourceTest >> testUnits [
	self assert: model allDelphiUnits size equals: 2
]

{ #category : #hooks }
FKDelphiTwoUnitsWithSourceTest >> unitA [
	^ 'unit UnitA;

end.
'
]

{ #category : #hooks }
FKDelphiTwoUnitsWithSourceTest >> unitAPas [
	^ 'unit UnitA;

end.
'
]

{ #category : #hooks }
FKDelphiTwoUnitsWithSourceTest >> unitB [
	^ 'unit UnitB;

end.
'
]

{ #category : #hooks }
FKDelphiTwoUnitsWithSourceTest >> unitBPas [
	^ 'unit UnitB;

end.
'
]
