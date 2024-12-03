Class {
	#name : #MooseDescriptionNotInitializedError,
	#superclass : #Error,
	#category : #GToolkit4Famix3
}

{ #category : #'as yet unclassified' }
MooseDescriptionNotInitializedError >> gtResetMetaFor: anAction [
	<gtAction>
	^ anAction button
		priority: 1;
		label: 'Reset meta';
		icon: BrGlamorousVectorIcons play;
		tooltip: 'Reset the default meta descriptions';
		action: [ MooseModel resetMeta ]
]

{ #category : #'as yet unclassified' }
MooseDescriptionNotInitializedError >> initialize [
	super initialize.
	messageText := 'Moose description are not initialized. Have you refreshed the meta-model? (e.g., MooseModel resetMeta)'
]
