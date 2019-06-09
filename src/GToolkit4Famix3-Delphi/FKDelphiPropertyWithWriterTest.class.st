Class {
	#name : #FKDelphiPropertyWithWriterTest,
	#superclass : #FKDelphiTestCase,
	#category : #'GToolkit4Famix3-Delphi-Tests'
}

{ #category : #testing }
FKDelphiPropertyWithWriterTest >> testAttributes [
	self assert: model allAttributes size equals: 1
]

{ #category : #testing }
FKDelphiPropertyWithWriterTest >> testTypes [
	self assert: model allTypes size equals: 1
]

{ #category : #hooks }
FKDelphiPropertyWithWriterTest >> unitPas [
	^ 'unit Unit;
interface 
	type
		T = class(TForm)
		private
			procedure _setCaption(Value:String);
		public
			property Caption:string write _setCaption;
	end;
implementation
	procedure T._setCaption(Value: String);
	begin
	  Inherited Caption := Value;
	end;
end.'
]
