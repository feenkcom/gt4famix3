Class {
	#name : #BaselineOfGToolkit4Famix3,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4Famix3
}

{ #category : #baseline }
BaselineOfGToolkit4Famix3 >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'Famix3SmalltalkImporter' with: [
				spec repository: 'github://feenkcom/famix3:v0.8.19/src' ].
		spec
			baseline: 'GToolkit4XMLSupport' with: [
				spec repository: 'github://feenkcom/gt4xmlsupport:v0.8.20/src' ].

		spec package: 'GToolkit4Famix3' with: [
			spec requires: #('Famix3SmalltalkImporter') ].
		spec package: 'GToolkit4Famix3-JavaScript' with: [
			spec requires: #('Famix3SmalltalkImporter') ].
		spec package: 'GToolkit4Famix3-VisualStudio' with: [
			spec requires: #('GToolkit4XMLSupport') ].
	]
]
