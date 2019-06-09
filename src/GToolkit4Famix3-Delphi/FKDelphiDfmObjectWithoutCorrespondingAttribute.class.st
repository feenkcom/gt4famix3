Class {
	#name : #FKDelphiDfmObjectWithoutCorrespondingAttribute,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #hooks }
FKDelphiDfmObjectWithoutCorrespondingAttribute >> files [
	^ { #unitPas . #unitDfm}
]

{ #category : #testing }
FKDelphiDfmObjectWithoutCorrespondingAttribute >> testObject [
	self assert: model allDelphiFormObjects size equals: 3.
	self assert: (model allDelphiFormObjects select: #isRoot) size equals: 1.
	self assert: model allDelphiFormObjects first targetEntity class equals: FKDelphiUnitVariable.
	self assert: model allDelphiFormObjects first targetEntity name equals: 'SomeName'.
	self assert: model allDelphiFormObjects first targetEntity isStub.
	model allDelphiFormObjects do: [ :each | 
		self assert: each targetEntity notNil.
		self assert: (each targetEntity delphiFormObjects includes: each) ]
]

{ #category : #testing }
FKDelphiDfmObjectWithoutCorrespondingAttribute >> testProperties [
	| root |
	root := model allDelphiFormObjects detect: #isRoot.
	self assert: root objectProperties size equals: 6.
	self assert: root objects anyOne objectProperties size equals: 2.
	self assert: root objects anyOne objects anyOne objectProperties size equals: 1.
	self assert: (root objectPropertyNamed: 'StringProperty') propertyValue equals: 'string'.
	self assert: (root objectPropertyNamed: 'ArrayProperty') propertyValue equals: ('one', String cr, 'two', String cr, 'three').
	self assert: (root objectPropertyNamed: 'CombinedStringProperty') propertyValue equals: ('onetwo', String cr, 'three')
]

{ #category : #testing }
FKDelphiDfmObjectWithoutCorrespondingAttribute >> testUnits [
	self assert: model allDelphiUnits size equals: 2
]

{ #category : #hooks }
FKDelphiDfmObjectWithoutCorrespondingAttribute >> unitDfm [
	^
'object SomeName: TypeWithoutVariable
  BooleanProperty = False
  StringProperty = ''string''
  ArrayProperty = (
      ''one''
      ''two''
      ''three'')
  CombinedStringProperty = (
		''one'' +
		''two''
		''three'')
  Height = 910
  Width = 1520
  object AttributeA: AnotherTypeA
    Left = 712
    Top = 8
	object ObjectTypeWithoutVariableName
      Another.Property = 42
    end
  end
end'
]

{ #category : #hooks }
FKDelphiDfmObjectWithoutCorrespondingAttribute >> unitPas [
	^
'unit Unit;
interface 
	type
		TypeWithoutVariable = class(SuperTypeA)
			AttributeA: AnotherTypeA;
		end;
end.
'
]
