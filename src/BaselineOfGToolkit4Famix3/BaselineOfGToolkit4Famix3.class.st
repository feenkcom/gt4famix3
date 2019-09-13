Class {
	#name : #BaselineOfGToolkit4Famix3,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4Famix3
}

{ #category : #baseline }
BaselineOfGToolkit4Famix3 >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec baseline: 'Famix3SmalltalkImporter' with: [
				spec repository: 'github://feenkcom/famix3:v0.7.6/src' ].
		spec package: 'GToolkit4Famix3' with: [
				spec requires: #('Famix3SmalltalkImporter' ). ]. ].

]
