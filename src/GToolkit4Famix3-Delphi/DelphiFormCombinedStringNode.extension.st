Extension { #name : #DelphiFormCombinedStringNode }

{ #category : #'*GToolkit4Famix3-Delphi' }
DelphiFormCombinedStringNode >> delphiToPharoValue [
	^ self left delphiToPharoValue, self right delphiToPharoValue
]
