Class {
	#name : #BaselineOfGToolkit4Famix3,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4Famix3
}

{ #category : #baselines }
BaselineOfGToolkit4Famix3 >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			spec 
				baseline: 'Famix3SmalltalkImporter' with: [
					spec repository: 'github://feenkcom/famix3/src' ];
				baseline: 'GToolkit' with: [
					spec repository: 'github://feenkcom/gtoolkit/src' ].
			spec 
				package: 'GToolkit4Famix3' with: [
					spec requires: #('Famix3SmalltalkImporter') ]	].

]
