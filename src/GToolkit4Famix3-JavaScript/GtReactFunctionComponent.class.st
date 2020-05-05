Class {
	#name : #GtReactFunctionComponent,
	#superclass : #FAMIXFunction,
	#instVars : [
		'incomingReactComponentReferences'
	],
	#category : #'GToolkit4Famix3-JavaScript-React'
}

{ #category : #accessing }
GtReactFunctionComponent >> incomingReactComponentReferences [
	<MSEProperty: #incomingReactComponentReferences type: #GtReactComponentReference opposite: #candidates>
	<multivalued>
	^ incomingReactComponentReferences
]

{ #category : #accessing }
GtReactFunctionComponent >> incomingReactComponentReferences: aCollection [
	incomingReactComponentReferences value: aCollection
]

{ #category : #'initialize-release' }
GtReactFunctionComponent >> initialize [
	super initialize.
	incomingReactComponentReferences := FMMultiMultivalueLink
		on: self
		opposite: #candidates
]
