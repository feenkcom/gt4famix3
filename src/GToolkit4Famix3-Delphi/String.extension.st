Extension { #name : #String }

{ #category : #'*GToolkit4Famix3-Delphi' }
String >> pharoFromDelphiString [
	^ (self removeSuffix: '''') removePrefix: ''''
]
