Extension { #name : #DelphiFormArrayNode }

{ #category : #'*GToolkit4Famix3-Delphi' }
DelphiFormArrayNode >> delphiToPharoValue [
	^ String cr join: (values collect: [ :each | each delphiToPharoValue ])
]
