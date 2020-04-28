Extension { #name : #FAMIXBehaviouralEntity }

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXBehaviouralEntity >> outgoingReactComponentReferences [
	<MSEProperty: #outgoingReactComponentReferences type: #GtReactComponentReference
	opposite: #sender>
	^ self privateState
		attributeAt: #outgoingReactComponentReferences
		ifAbsentPut: [ FMMultivalueLink on: self opposite: #sender: ]
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXBehaviouralEntity >> outgoingReactComponentReferences: aCollection [
	^ self outgoingReactComponentReferences value: aCollection
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXBehaviouralEntity >> potentialJSEntities [
	<MSEProperty: #potentialJSEntities type: #FAMIXFunction opposite: #potentialJSFunctions>
	<multivalued>
	<derived>
	<MSEComment: 'Potential entities that might hold a reference to this function'>
	^ self privateState attributeAt: #fkPotentialJSEntities ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #potentialJSFunctions ]
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXBehaviouralEntity >> potentialJSEntities: aCollection [
	^ self potentialJSEntities value: aCollection
]
