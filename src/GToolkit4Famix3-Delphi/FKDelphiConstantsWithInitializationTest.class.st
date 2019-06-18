Class {
	#name : #FKDelphiConstantsWithInitializationTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #testing }
FKDelphiConstantsWithInitializationTest >> testUnit [
	self assert: model allDelphiUnitConstants size equals: 1.
	self assert: model allDelphiConstantAttributes size equals: 1
]

{ #category : #hooks }
FKDelphiConstantsWithInitializationTest >> unitPas [
	^ 'unit Unit;

interface
	type T = class
		const
			CONSTANT = chr(42);
	end;

	const
		CONSTANT = chr(42);

end.
'
]
