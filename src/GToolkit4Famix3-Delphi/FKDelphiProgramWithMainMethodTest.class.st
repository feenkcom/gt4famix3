Class {
	#name : #FKDelphiProgramWithMainMethodTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #hooks }
FKDelphiProgramWithMainMethodTest >> files [
	^ { #programDpr }
]

{ #category : #hooks }
FKDelphiProgramWithMainMethodTest >> programDpr [
	^ 'program Program;
	
{$R *.res}

begin
	Proc();
end.
'
]

{ #category : #testing }
FKDelphiProgramWithMainMethodTest >> testProgram [
	self assert: model allDelphiPrograms size equals: 1.
	self assert: model allDelphiPrograms anyOne functions size equals: 1.
	self assert: model allDelphiPrograms anyOne functions anyOne name equals: '__MAIN__'.
]
