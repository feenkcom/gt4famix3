Class {
	#name : #FKDelphiOneUnitWithFunctionsAndAClassTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testAttributes [
	self assert: model allAttributes size equals: 1
]

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testFunctions [
	self assert: model allFunctions size equals: 2.
	self assert: model allFunctions anyOne container equals: model allDelphiUnits anyOne
]

{ #category : #testing }
FKDelphiOneUnitWithFunctionsAndAClassTest >> testMethods [
	self assert: model allMethods size equals: 2.
	self assert: (model allMethods anySatisfy: [ :m | m mooseName = 'Unit::TypeA.Proc' ])
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
