Class {
	#name : #GtJSObjectBindingParameter,
	#superclass : #FAMIXParameter,
	#category : #'GToolkit4Famix3-JavaScript-Model'
}

{ #category : #accessing }
GtJSObjectBindingParameter >> reactProperties [
	<MSEProperty: #reactProperties type: #GtReactComponentReferenceProperty opposite: #parameters>
	<multivalued>
	^ self privateState
		attributeAt: #reactProperties
		ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #parameters ]
]

{ #category : #accessing }
GtJSObjectBindingParameter >> reactProperties: aCollection [
		self reactProperties nocheckValue: aCollection
]
