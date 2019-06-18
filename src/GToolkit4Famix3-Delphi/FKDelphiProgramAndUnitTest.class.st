Class {
	#name : #FKDelphiProgramAndUnitTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #hooks }
FKDelphiProgramAndUnitTest >> dprFiles [
	^ { #program }
]

{ #category : #hooks }
FKDelphiProgramAndUnitTest >> files [
	^ { #unitPas . #programDpr }
]

{ #category : #hooks }
FKDelphiProgramAndUnitTest >> program [
	^ 'program Program;
	
uses
	unit;

{$R *.res}

begin
end.
'
]

{ #category : #hooks }
FKDelphiProgramAndUnitTest >> programDpr [
	^ 'program Program;
	
uses
	Unit;

{$R *.res}

begin
end.
'
]

{ #category : #testing }
FKDelphiProgramAndUnitTest >> testProgram [
	self assert: model allDelphiPrograms size equals: 1.
	self assert: model allDelphiPrograms anyOne outgoingUsesAssociations size equals: 1.
	self 
		assert: model allDelphiPrograms anyOne outgoingUsesAssociations anyOne usedUnit 
		equals: model allDelphiUnits anyOne.
	self assert: model allDelphiPrograms anyOne fkDelphiAST notNil
]

{ #category : #testing }
FKDelphiProgramAndUnitTest >> testUnit [
	self assert: model allDelphiUnits size equals: 1.
	self assert: model allDelphiUnits anyOne name equals: 'Unit'
]

{ #category : #hooks }
FKDelphiProgramAndUnitTest >> unit [
	^ 'unit Unit;

end.
'
]

{ #category : #hooks }
FKDelphiProgramAndUnitTest >> unitPas [
	^ 'unit Unit;

end.
'
]
