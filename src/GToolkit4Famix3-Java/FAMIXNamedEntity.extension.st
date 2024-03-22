Extension { #name : #FAMIXNamedEntity }

{ #category : #'*GToolkit4Famix3-Java' }
FAMIXNamedEntity >> outgoingGtJavaSpringCalls [
	<MSEProperty: #outgoingGtJavaSpringCalls type: #GtJavaSpringCall opposite: #caller>
	<multivalued>
	<derived>
	^ self
		propertyNamed: #outgoingGtJavaSpringCalls
		ifAbsentPut: [ GtJavaSpringCallGroup new ]
]
