Extension { #name : #SmaCCCaseInsensitiveToken }

{ #category : #'*GToolkit4Famix3-Delphi' }
SmaCCCaseInsensitiveToken >> delphiToPharoValue [
	^ (self value removePrefix: '''') removeSuffix: ''''
]
