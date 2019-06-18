Class {
	#name : #FKDelphiTypeWithVarsTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #testing }
FKDelphiTypeWithVarsTest >> testUnit [
	self assert: model allModelTypes size equals: 1.
	self assert: model allAttributes size equals: 1
]

{ #category : #hooks }
FKDelphiTypeWithVarsTest >> unitPas [
	^ 'unit Unit;
interface
type
	TypeA = class
		strict private
		const
			CONST = 42;
		var
			DictionaryVariable: TDictionary<integer, integer>;
	end;
end.'
]
