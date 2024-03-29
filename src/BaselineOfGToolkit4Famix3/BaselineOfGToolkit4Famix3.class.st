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
				spec repository: 'github://feenkcom/famix3:main/src' ];
			baseline: 'GToolkit4XMLSupport' with: [
				spec repository: 'github://feenkcom/gt4xmlsupport:main/src' ].
		spec 
			package: 'GToolkit4Famix3' with: [
				spec requires: #('Famix3SmalltalkImporter' ). ];
			package: 'GToolkit4Famix3-JavaScript' with: [
				spec requires: #('Famix3SmalltalkImporter' ). ];
			package: 'GToolkit4Famix3-Java' with: [
				spec requires: #('Famix3SmalltalkImporter' ). ];
			package: 'GToolkit4Famix3-VisualStudio' with: [
				spec requires: #('GToolkit4XMLSupport' ). ]. ].

]
