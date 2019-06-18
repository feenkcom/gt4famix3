Class {
	#name : #FKDelphiFunctionsWithImplementationsTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #testing }
FKDelphiFunctionsWithImplementationsTest >> testFunctions [
	self assert: model allFunctions size equals: 2.
	(model allFunctions reject: #isStub) do: [ :f | 
		self assert: (f container name = #'Unit') ].
	self assert: (model allFunctions entityNamed: 'Unit.Func') isStub not.
	self assert: (model allFunctions entityNamed: 'Unit.Proc') isStub not
]

{ #category : #testing }
FKDelphiFunctionsWithImplementationsTest >> testFunctionsHaveAST [
	(model allFunctions reject: #isStub) do: [ :f | 
		self assert: f fkDelphiAST notNil ]
]

{ #category : #testing }
FKDelphiFunctionsWithImplementationsTest >> testFunctionsSourceAnchor [
	(model allFunctions reject: #isStub) do: [ :function |
		self assert: (function sourceText includesSubstring: 'begin').
		self assert: (function sourceText includesSubstring: 'end;'). ]
]

{ #category : #testing }
FKDelphiFunctionsWithImplementationsTest >> testInvocations [
	self assert: model allInvocations size equals: 4.
	model allInvocations do: [ :each | self assert: each fkDelphiAST notNil ].
	self assert: (model allFunctions entityNamed: 'Unit.Func') outgoingInvocations size equals: 3.
	self assert: (model allFunctions entityNamed: 'Unit.Func') outgoingInvocations first candidates size equals: 1.
	self assert: (model allFunctions entityNamed: 'Unit.Func') outgoingInvocations last candidates size equals: 1
]

{ #category : #testing }
FKDelphiFunctionsWithImplementationsTest >> testStubFunctionsDontHaveAST [
	(model allFunctions select: #isStub) do: [ :f | self assert: f fkDelphiAST isNil ]
	
]

{ #category : #hooks }
FKDelphiFunctionsWithImplementationsTest >> unitPas [
	^ 'unit Unit;

interface

function Func(): String;
procedure Proc();

implementation

function Func(): String; 
begin
	Proc;
	Proc();
	Unit.Proc();
end;

procedure Proc();
begin
	B();
end;


end.
'
]
