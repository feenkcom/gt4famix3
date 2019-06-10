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
	#category : #GToolkit4Famix3
}

{ #category : #accessing }
FAMIXComponent >> entities [
	^ entities
]

{ #category : #accessing }
FAMIXComponent >> entities: anObject [
	entities := anObject
]

{ #category : #accessing }
FAMIXComponent >> incomingDependencies [
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
	outgoingDependencies := FMNullMultivalueLink on: self opposite: #source selector: #outgoingDependencies.
	incomingDependencies := FMNullMultivalueLink on: self opposite: #target selector: #incomingDependencies.
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
	^ outgoingDependencies
]

{ #category : #accessing }
FAMIXComponent >> outgoingDependencies: anObject [
	outgoingDependencies := anObject
]
