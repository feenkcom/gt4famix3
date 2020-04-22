Class {
	#name : #GtJSInvocation,
	#superclass : #FAMIXInvocation,
	#instVars : [
		'arguments'
	],
	#category : #'GToolkit4Famix3-JavaScript-Model'
}

{ #category : #accessing }
GtJSInvocation >> arguments [
	<MSEProperty: #arguments type: #String>
	<multivalued>
	<MSEComment: 'The argument entities for the function invocation'>
	^ arguments ifNil: [ arguments := GtMultivalueNullableLink on: self opposite: #jsInvocation: ]
]

{ #category : #accessing }
GtJSInvocation >> arguments: aCollection [
	self arguments value: aCollection
]
