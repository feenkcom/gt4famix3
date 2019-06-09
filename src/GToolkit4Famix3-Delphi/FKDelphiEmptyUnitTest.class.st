Class {
	#name : #FKDelphiEmptyUnitTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #testing }
FKDelphiEmptyUnitTest >> testAST [
	self assert: model allDelphiUnits anyOne fkDelphiAST notNil
]

{ #category : #testing }
FKDelphiEmptyUnitTest >> testLoggerIsEmpty [
	self assert: logger recordings isEmpty
]

{ #category : #testing }
FKDelphiEmptyUnitTest >> testUnit [
	self assert: model allDelphiUnits size equals: 1.
	self assert: model allNamespaces size equals: 2.
	self assert: model allDelphiUnits anyOne name equals: 'Unit'.
	self assert: model allDelphiUnits anyOne mooseName equals: 'Namespace::Unit'
]

{ #category : #hooks }
FKDelphiEmptyUnitTest >> unit [
	^ 'unit Namespace.Unit;

end.
'
]

{ #category : #hooks }
FKDelphiEmptyUnitTest >> unitPas [
	^ 'unit Namespace.Unit;

end.
'
]
