"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestFKDelphi,
	#superclass : #PackageManifest,
	#category : #'GToolkit4Famix3-Delphi'
}

{ #category : #'code-critics' }
ManifestFKDelphi class >> ruleRBCollectionMessagesToExternalObjectRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#FKDelphiScopingEntity #lookupFunctionNamed:havingTraversed: #false)) #'2016-10-26T01:13:17.299621+02:00') )
]
