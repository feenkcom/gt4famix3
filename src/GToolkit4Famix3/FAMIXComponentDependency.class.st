Class {
	#name : #FAMIXComponentDependency,
	#superclass : #FAMIXEntity,
	#instVars : [
		'source',
		'target',
		'entityDependencies'
	],
	#category : 'GToolkit4Famix3'
}

{ #category : #accessing }
FAMIXComponentDependency >> addEntityDependency: anEntityDependency [
	self entityDependencies add: anEntityDependency 
]

{ #category : #accessing }
FAMIXComponentDependency >> entityDependencies [
	^ entityDependencies
]

{ #category : #accessing }
FAMIXComponentDependency >> entityDependencies: anObject [
	entityDependencies := anObject
]

{ #category : #accessing }
FAMIXComponentDependency >> gtDisplayOn: aStream [
	self source gtDisplayOn: aStream.
	aStream nextPutAll: ' -> '.
	self target gtDisplayOn: aStream.
]

{ #category : #accessing }
FAMIXComponentDependency >> gtEntityDependenciesFor: aView [
	<gtView>
	^ aView columnedList 
		title: 'Dependencies';
		priority: 0;
		items: [ self entityDependencies ];
		column: 'Source' text: [:e | e source gtDisplayString];
		column: 'Target' text: [:e | e target gtDisplayString]
]

{ #category : #inititialize }
FAMIXComponentDependency >> initialize [
	super initialize.
	entityDependencies := OrderedCollection new
]

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
