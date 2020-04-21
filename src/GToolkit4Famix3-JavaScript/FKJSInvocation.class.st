Class {
	#name : #FKJSInvocation,
	#superclass : #FAMIXInvocation,
	#instVars : [
		'arguments'
	],
	#category : #'GToolkit4Famix3-JavaScript-Dojo'
}

{ #category : #accessing }
FKJSInvocation >> arguments [
	<MSEProperty: #arguments type: #String>
	<multivalued>
	<MSEComment: 'The argument entities for the function invocation'>
	^ arguments ifNil: [ arguments := FKMultivalueNullableLink on: self opposite: #jsInvocation: ]
]

{ #category : #accessing }
FKJSInvocation >> arguments: aCollection [
	self arguments value: aCollection
]
