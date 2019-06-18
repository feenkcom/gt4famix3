Class {
	#name : #FKDelphiRecordTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #testing }
FKDelphiRecordTest >> testTypes [
	self assert: model allModelTypes size equals: 2
]

{ #category : #hooks }
FKDelphiRecordTest >> unitPas [
	^ 'unit Unit;

interface

type
	RecordType = record
		integerVar: INTEGER;
		doubleVar1, doubleVar2: DOUBLE;
		booleanVar: Boolean;
	end;

implementation

function Func(): String; 
type
	RecordType = record
		integerVar: INTEGER;
		doubleVar1, doubleVar2: DOUBLE;
		booleanVar: Boolean;
	end;
begin
	Proc();
end;

end.
'
]
