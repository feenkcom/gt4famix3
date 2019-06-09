Class {
	#name : #FKDelphiOneUnitWithFunctionsAndAClassTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testAttributes [
	self assert: model allAttributes size equals: 2.
	self assert: model allAttributes anyOne isStub not.
	self assert: model allAttributes anyOne fkDelphiAST notNil
]

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testAttributesHaveDeclaredType [
	model allAttributes do: [ :each | 
		self assert: each declaredType notNil.
		self assert: each declaredType isStub.
		self assert: each declaredType namespaceScope equals: model delphiUnknownUnit ].
	self 
		assert: (model allAttributes entityNamed: 'Unit::TypeA.StringAttribute') declaredType name
		equals: 'String'
]

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testFuncHasDeclaredType [
	| func |
	func := model allFunctions entityNamed: 'Unit.Func'.
	self assert: func notNil.
	self assert: func declaredType notNil.
	self assert: func declaredType isStub.
	self assert: func declaredType container equals: model delphiUnknownUnit	
]

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testFunctions [
	self assert: model allFunctions size equals: 2.
	self assert: model allFunctions anyOne container name equals: 'Unit'
]

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testInheritances [
	self assert: model allInheritanceDefinitions size equals: 1.
	model allInheritanceDefinitions do: [ :inheritance |
		self assert: inheritance subclass notNil.
		self assert: inheritance fkDelphiAST notNil ]
]

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testLocalVariables [
	self assert: model allLocalVariables size equals: 1.
	self assert: model allLocalVariables anyOne isStub not.
	self assert: model allLocalVariables anyOne fkDelphiAST notNil
]

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testLocalVariablesHaveDeclaredType [
	model allLocalVariables do: [ :each | 
		self assert: each declaredType notNil.
		self assert: each declaredType isStub.
		self assert: each declaredType namespaceScope equals: model delphiUnknownUnit ].
	self 
		assert: (model allLocalVariables entityNamed: 'Unit.Proc.ProcXStringVariable') declaredType name
		equals: 'String'
]

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testMethods [
	self assert: model allMethods size equals: 2.
	self assert: (model allMethods anySatisfy: [ :m | m mooseName = 'Unit::TypeA.Proc' ])
]

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testMethodsHaveDeclaredType [
	| func |
	func := model allMethods entityNamed: 'Unit::TypeA.Func'.
	self assert: func notNil.
	self assert: func declaredType notNil.
	self assert: func declaredType isStub.
	self assert: func declaredType container equals: model delphiUnknownUnit	
]

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testModelTypes [
	self assert: model allModelTypes size equals: 2.
	self assert: model allModelTypes anyOne container name equals: 'Unit'.
	self assert: model allTypes anyOne fkDelphiAST notNil.
	self assert: (model allTypes select: [ :each | each isStub ]) size equals: 2
]

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testParameters [
	self assert: model allParameters size equals: 5.
	self assert: model allParameters anyOne isStub not.
	self assert: model allParameters anyOne fkDelphiAST notNil.
	model allParameters do: [ :each | 
		self assert: each declaredType notNil ]
]

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testScopedVariables [
	self assert: model allDelphiScopedVariables size equals: 4.
	self assert: model allDelphiScopedVariables anyOne isStub not.
	self assert: model allDelphiScopedVariables anyOne fkDelphiAST notNil
]

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testScopedVariablesHaveDeclaredType [
	model allDelphiScopedVariables do: [ :each | 
		self assert: each declaredType notNil.
		self assert: each declaredType isStub.
		self assert: each declaredType namespaceScope equals: model delphiUnknownUnit ].
	self 
		assert: (model allDelphiScopedVariables entityNamed: 'Unit::InterfaceStringVariable') declaredType name
		equals: 'String'
]

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testStubTypes [
	self assert: (model allTypes select: [ :each | each isStub ]) size equals: 2.
	(model allTypes select: [ :each | each isStub ]) do: [ :type |
		self assert: type container name equals: FKDelphiUnit unknownUnitName ]
	
]

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testTypes [
	self assert: model allTypes size equals: 1.
	self assert: model allTypes anyOne container equals: model allDelphiUnits anyOne
]

{ #category : #hooks }
FKDelphiOneUnitWithFunctionsAndAClassTest >> unit [
	^ 'unit Unit;

interface

function Func(): String;
procedure Proc();

type
  TypeA = class(TForm)
	 Attribute: TImage;
    procedure TypeA.Proc();
    function TypeA.Func(): Integer;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

end.
'
]

{ #category : #hooks }
FKDelphiOneUnitWithFunctionsAndAClassTest >> unitPas [
	^ 'unit Unit;

interface
	function Func(): String;
	procedure Proc(StringArgument: String; IntegerArgument: Integer);
	type
		SuperType = class
		end;
		TypeA = class(SuperType)
			StringAttribute: String;
			IntegerAttribute: Integer;
			procedure TypeA.Proc(StringArgument: String; IntegerArgument: Integer);
			function TypeA.Func(IntegerArgument: Integer): Integer;
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

	procedure Proc(StringArgument: String; IntegerArgument: Integer);
	var
		ProcXStringVariable: String;
	begin
	end;

end.
'
]
