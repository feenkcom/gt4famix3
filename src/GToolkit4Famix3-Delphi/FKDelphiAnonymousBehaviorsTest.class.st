Class {
	#name : #FKDelphiAnonymousBehaviorsTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #testing }
FKDelphiAnonymousBehaviorsTest >> testUnit [
	self assert: model allModelTypes size equals: 3
]

{ #category : #hooks }
FKDelphiAnonymousBehaviorsTest >> unitPas [
	^ 'unit Unit;
interface
type
	TIntegerFunction = function: Integer;
   TProcedure = procedure(const S: String; I: Integer);
   TMethod = procedure of object;
end.'
]
