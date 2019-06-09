Class {
	#name : #FKDelphiDfmObjectWithProperties,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #hooks }
FKDelphiDfmObjectWithProperties >> files [
	^ { #unitPas . #unitDfm}
]

{ #category : #testing }
FKDelphiDfmObjectWithProperties >> testObject [
	self assert: model allDelphiFormObjects size equals: 2.
	self assert: model allDelphiFormObjects last parentObject equals: model allDelphiFormObjects first.
	self assert: model allDelphiFormObjects first targetEntity class equals: FKDelphiUnitVariable.
	self assert: model allDelphiFormObjects first targetEntity name equals: 'VariableA'.
	model allDelphiFormObjects do: [ :each | self assert: each targetEntity notNil ]
]

{ #category : #testing }
FKDelphiDfmObjectWithProperties >> testUnits [
	self assert: model allDelphiUnits size equals: 2
]

{ #category : #hooks }
FKDelphiDfmObjectWithProperties >> unitDfm [
	^
'object VariableA: TypeA
  BooleanProperty = False
  Height = 910
  Width = 1520
  object AttributeA: AnotherTypeA
    SomeProperty = Someting
    Left = 712
    Top = 8
  end
end'
]

{ #category : #hooks }
FKDelphiDfmObjectWithProperties >> unitPas [
	^
'unit Unit;
interface 
	type
		TypeA = class(SuperTypeA)
			AttributeA: AnotherTypeA;
		end;
	var
	  VariableA: TypeA;
end.
'
]
