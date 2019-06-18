Class {
	#name : #FKDelphiAttributesTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #testing }
FKDelphiAttributesTest >> testUnit [
	self assert: model allDelphiUnits size equals: 1.
	self assert: model allNamespaces size equals: 2.
	self assert: model allDelphiUnits anyOne name equals: 'Unit'.
	self assert: model allDelphiUnits anyOne mooseName equals: 'Namespace::Unit'
]

{ #category : #hooks }
FKDelphiAttributesTest >> unitPas [
	^ 'unit Namespace.Unit;

interface 



end.
'
]
