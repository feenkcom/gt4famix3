Class {
	#name : #FAMIXComponentDependency,
	#superclass : #FAMIXEntity,
	#instVars : [
		'source',
		'target'
	],
	#category : #GToolkit4Famix3
}

{ #category : #accessing }
FAMIXComponentDependency >> source [
	^ source
]

{ #category : #accessing }
FAMIXComponentDependency >> source: aComponent [
	source := FMMultivalueLink on: self
					update: #outgoingDependencies
					from: self source
					to: aComponent
]

{ #category : #accessing }
FAMIXComponentDependency >> target [
	^ target
]

{ #category : #accessing }
FAMIXComponentDependency >> target: aComponent [
	target := FMMultivalueLink on: self
					update: #incomingDependencies
					from: self target
					to: aComponent
]
