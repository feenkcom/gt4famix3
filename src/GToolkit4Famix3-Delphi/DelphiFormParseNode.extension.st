Extension { #name : #DelphiFormParseNode }

{ #category : #'*GToolkit4Famix3-Delphi' }
DelphiFormParseNode >> delphiToPharoValue [
	^ (self value value asString removePrefix: '''') removeSuffix: ''''
]
