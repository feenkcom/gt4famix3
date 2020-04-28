Class {
	#name : #GtReactFunctionComponent,
	#superclass : #FAMIXFunction,
	#instVars : [
		'incomingElements'
	],
	#category : #'GToolkit4Famix3-JavaScript-React'
}

{ #category : #accessing }
GtReactFunctionComponent >> incomingElements [
	<MSEProperty: #incomingElements type: #GtReactComponentReference opposite: #candidates>
	<multivalued>
	^ incomingElements
]

{ #category : #accessing }
GtReactFunctionComponent >> incomingElements: aCollection [
	incomingInvocations value: aCollection
]

{ #category : #'initialize-release' }
GtReactFunctionComponent >> initialize [
	super initialize.
	incomingElements := FMMultiMultivalueLink
		on: self
		opposite: #candidates
]
