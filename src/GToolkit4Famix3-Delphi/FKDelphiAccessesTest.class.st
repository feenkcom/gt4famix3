Class {
	#name : #FKDelphiAccessesTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #testing }
FKDelphiAccessesTest >> testProcWithArrayWriteAccesses [
	| accesses |
	accesses := (model allFunctions entityNamed: #'Unit.ProcWithArrayWriteAccess') accesses.
	self assert: accesses size equals: 4.
	accesses do: [ :access | self assert: access variable notNil ]
]

{ #category : #testing }
FKDelphiAccessesTest >> testProcWithReadAssignmentAccesses [
	| accesses |
	accesses := (model allFunctions entityNamed: #'Unit.ProcWithReadAssignmentAccesses') accesses.
	self assert: accesses size equals: 8.
	self assert: (accesses select: #isRead) size equals: 4.
	accesses do: [ :access | self assert: access variable notNil ]
]

{ #category : #testing }
FKDelphiAccessesTest >> testProcWithWriteAccesses [
	| accesses |
	accesses := (model allFunctions entityNamed: #'Unit.ProcWithWriteAccesses') accesses.
	self assert: accesses size equals: 4.
	accesses do: [ :access | self assert: access variable notNil ]
]

{ #category : #testing }
FKDelphiAccessesTest >> testTypeAProcWithReadAssignmentAccesses [
	| accesses |
	accesses := (model allMethods entityNamed: #'Unit::TypeA.ProcWithReadAssignmentAccesses') accesses.
	self assert: accesses size equals: 8.
	self assert: (accesses select: #isRead) size equals: 4.
	accesses do: [ :access | self assert: access variable notNil ]
]

{ #category : #hooks }
FKDelphiAccessesTest >> unitPas [
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
		private
			{ Private-Deklarationen }
		public
			{ Public-Deklarationen }
		end;
	var
		InterfaceStringVariable: String;
		InterfaceIntegerVariable: Integer;
implementation
	var
		ImplementationStringVariable: String;
		ImplementationIntegerVariable: Integer;

	procedure ProcWithWriteAccesses(StringArgument: String; IntegerArgument: Integer);
	var
		ProcXStringVariable: String;
	begin
		InterfaceStringVariable := ''String'';
		ImplementationStringVariable := ''String'';
		ProcXStringVariable := ''String'';
		StringArgument := ''String'';
		
	end;

	procedure ProcWithReadAssignmentAccesses(StringArgument: String);
	var
		ProcXStringVariable: String;
	begin
		ProcXStringVariable := InterfaceStringVariable;
		ProcXStringVariable := ImplementationStringVariable;
		ProcXStringVariable := ProcXStringVariable;
		ProcXStringVariable := StringArgument;
	end;
	
	procedure TypeA.ProcWithReadAssignmentAccesses(StringArgument: String);
	var
		ProcXStringVariable: String;
	begin
		ProcXStringVariable := InterfaceStringVariable;
		ProcXStringVariable := ImplementationStringVariable;
		ProcXStringVariable := ProcXStringVariable;
		ProcXStringVariable := StringArgument;
	end;
	
	procedure ProcWithArrayWriteAccess;
	var
		ProcArray : Array of String;
		ProcString : String;
	begin
		ProcArray[0] := ''String'';
		ProcString := ProcArray[0];
	end;

end.
'
]
