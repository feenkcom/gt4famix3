Extension { #name : #FAMIXNamedEntity }

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXNamedEntity >> addPotentialJSFunction: aFunction [
	self potentialJSFunctions add: aFunction
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXNamedEntity >> allPotentialJSFunctionsDo: aBlock [
	self potentialJSFunctions do: aBlock
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXNamedEntity >> jsInvocation [
	^ self privateState attributeAt: #jsInvocation ifAbsent: [  ]
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXNamedEntity >> jsInvocation: anInvocation [
	^ self privateState attributeAt: #jsInvocation put: anInvocation
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXNamedEntity >> potentialJSFunctions [
	<MSEProperty: #potentialJSFunctions type: #FAMIXFunction opposite: #potentialJSEntities>
	<multivalued>
	<derived>
	<MSEComment: 'Potential functions this entity may be referencing'>
	^ self privateState attributeAt: #fkPotentialJSFunctions ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #potentialJSEntities ]
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXNamedEntity >> potentialJSFunctions: aCollection [
	^ self potentialJSFunctions value: aCollection
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXNamedEntity >> removePotentialJSFunction: aFunction [
	self potentialJSFunctions remove: aFunction
]
