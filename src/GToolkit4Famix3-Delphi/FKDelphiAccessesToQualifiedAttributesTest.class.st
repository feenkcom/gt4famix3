Class {
	#name : #FKDelphiAccessesToQualifiedAttributesTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #testing }
FKDelphiAccessesToQualifiedAttributesTest >> testProcWithWriteAccesses [
	| accesses |
	accesses := (model allFunctions entityNamed: #'Unit.ProcWithWriteAccesses') accesses.
	self assert: accesses size equals: 4.
	accesses do: [ :access | self assert: access variable notNil ]
]

{ #category : #hooks }
FKDelphiAccessesToQualifiedAttributesTest >> unitPas [
	^ 'unit Unit;

interface
	function Func(): String;
	procedure ProcWithWriteAccesses(StringArgument: String);
	procedure ProcWithReadAssignmentAccesses(StringArgument: String);
	type
		SuperType = class
		end;
		TypeA = class(SuperType)
			StringAttribute: String;
			procedure TypeA.ProcWithReadAssignmentAccesses(StringArgument: String);
			function TypeA.ProcWithWriteAccesses(StringArgument: String): String;
		end;
implementation
	var
		ImplementationTypeAVariable: TypeA;

	procedure ProcWithWriteAccesses(StringArgument: String; IntegerArgument: Integer);
	begin
		ImplementationTypeAVariable.StringAttribute := ''String'';
	end;
end.
'
]
