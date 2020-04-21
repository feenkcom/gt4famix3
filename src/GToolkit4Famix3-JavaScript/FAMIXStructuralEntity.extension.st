Extension { #name : #FAMIXStructuralEntity }

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXStructuralEntity >> addRValueEntity: anEntity [
	self jsRValueEntities add: anEntity
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXStructuralEntity >> allPotentialJSFunctionsDo: aBlock [
	| seen todo item |
	seen := IdentitySet with: self.
	todo := OrderedCollection with: self.
	[ todo notEmpty ]
		whileTrue: [ item := todo removeFirst.
			item potentialJSFunctions do: aBlock.
			item jsRValueEntities
				do: [ :each | 
					(seen includes: each)
						ifFalse: [ seen add: each.
							todo add: each ] ] ]
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXStructuralEntity >> jsLValueEntities [
	<MSEProperty: #jsLValueEntities type: #FAMIXStructuralEntity opposite: #jsRValueEntities>
	<multivalued>
	<derived>
	<MSEComment: 'Other entities that are assigned our value'>
	^ self privateState
		attributeAt: #fkJSLValueEntities
		ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #jsRValueEntities ]
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXStructuralEntity >> jsLValueEntities: aCollection [
	^ self jsLValueEntities value: aCollection
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXStructuralEntity >> jsRValueEntities [
	<MSEProperty: #jsRValueEntities type: #FAMIXStructuralEntity opposite: #jsLValueEntities>
	<multivalued>
	<derived>
	<MSEComment: 'Other entities that are directly assigned to this entity'>
	^ self privateState
		attributeAt: #fkJSRValueEntities
		ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #jsLValueEntities ]
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXStructuralEntity >> jsRValueEntities: aCollection [
	^ self jsRValueEntities value: aCollection
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXStructuralEntity >> removeRValueEntity: anEntity [
	self jsRValueEntities remove: anEntity
]
