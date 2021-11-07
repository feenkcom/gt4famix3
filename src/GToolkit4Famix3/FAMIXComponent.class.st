"
A generic component

"
Class {
	#name : #FAMIXComponent,
	#superclass : #FAMIXEntity,
	#instVars : [
		'name',
		'outgoingDependencies',
		'incomingDependencies',
		'entities'
	],
	#category : 'GToolkit4Famix3'
}

{ #category : #accessing }
FAMIXComponent >> entities [
	<MSEProperty: #entities type: #FAMIXEntity>
	^ entities
]

{ #category : #accessing }
FAMIXComponent >> entities: anObject [
	entities := anObject
]

{ #category : #accessing }
FAMIXComponent >> gtEntitiesFor: aView [
	<gtView>
	^ aView list 
		title: 'Entities';
		priority: 0;
		items: [ self entities sorted: [:a :b | a gtDisplayString < b gtDisplayString ]]
]

{ #category : #accessing }
FAMIXComponent >> gtIncomingDependenciesFor: aView [
	<gtView>
	^ aView columnedList 
		title: 'Incoming';
		priority: 10;
		items: [ self incomingDependencies ];
		column: 'From' text: [ :each | each source gtDisplayString ];
		column: 'To' text: [:each | each target gtDisplayString ];
		column: 'Amount' text: [:each | each entityDependencies size] width: 100
]

{ #category : #accessing }
FAMIXComponent >> gtOutgoingDependenciesFor: aView [
	<gtView>
	^ aView columnedList 
		title: 'Outgoing';
		priority: 20;
		items: [ self outgoingDependencies ];
		column: 'From' text: [ :each | each source gtDisplayString ];
		column: 'To' text: [:each | each target gtDisplayString ];
		column: 'Amount' text: [:each | each entityDependencies size] width: 100
]

{ #category : #accessing }
FAMIXComponent >> incomingDependencies [
	<MSEProperty: #entities type: #FAMIXComponentDependency>
	^ incomingDependencies
]

{ #category : #accessing }
FAMIXComponent >> incomingDependencies: anObject [
	incomingDependencies := anObject
]

{ #category : #initialization }
FAMIXComponent >> initialize [
	super initialize.
	entities := OrderedCollection new.
	outgoingDependencies := FMNullMultivalueLink on: self opposite: #source: selector: #outgoingDependencies.
	incomingDependencies := FMNullMultivalueLink on: self opposite: #target: selector: #incomingDependencies.
]

{ #category : #accessing }
FAMIXComponent >> name [
	^ name
]

{ #category : #accessing }
FAMIXComponent >> name: anObject [
	name := anObject
]

{ #category : #accessing }
FAMIXComponent >> outgoingDependencies [
	<MSEProperty: #entities type: #FAMIXComponentDependency>
	^ outgoingDependencies
]

{ #category : #accessing }
FAMIXComponent >> outgoingDependencies: anObject [
	outgoingDependencies := anObject
]
