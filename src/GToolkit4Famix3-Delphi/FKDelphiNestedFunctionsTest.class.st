Class {
	#name : #FKDelphiNestedFunctionsTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #hooks }
FKDelphiNestedFunctionsTest >> testFunctions [
	self assert: model allFunctions size equals: 2
]

{ #category : #hooks }
FKDelphiNestedFunctionsTest >> unitPas [
	^ 'unit Unit;

interface

procedure Proc();

implementation

procedure Proc();

function Func(): String;
begin
	X();
end;

begin
	Func();
end;


end.
'
]
