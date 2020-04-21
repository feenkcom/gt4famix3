Extension { #name : #FAMIXBehaviouralEntity }

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXBehaviouralEntity >> isJSScript [
	^ false
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
