Class {
	#name : #FKDelphiMethodsWithImplementationsTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #testing }
FKDelphiMethodsWithImplementationsTest >> testMethods [
	self assert: model allFunctions isEmpty.
	self assert: model allMethods size equals: 2.
	(model allMethods reject: #isStub) do: [ :f | 
		self assert: (f parentType name = #'T') ].
	self assert: (model allMethods entityNamed: 'Unit::T.Func') isStub not.
	self assert: (model allMethods entityNamed: 'Unit::T.Proc') isStub not
]

{ #category : #testing }
FKDelphiMethodsWithImplementationsTest >> testMethodsSourceAnchor [
	(model allMethods reject: #isStub) do: [ :m |
		self assert: (m sourceText includesSubstring: 'begin').
		self assert: (m sourceText includesSubstring: 'end;'). ]
]

{ #category : #hooks }
FKDelphiMethodsWithImplementationsTest >> unitPas [
	^ 'unit Unit;

interface
	type T = class
		procedure Proc();
		function Func(): String;
	end; 

implementation
	function T.Func(): String; 
	begin
		Proc();
	end;
	procedure T.Proc();
	begin
		B();
	end;
end.
'
]
