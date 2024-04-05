Extension { #name : #FAMIXEntity }

{ #category : #'*GToolkit4Famix3' }
FAMIXEntity >> gtIcon [
	^ MooseIcons mooseMetamodelEntity
]

{ #category : #'*GToolkit4Famix3' }
FAMIXEntity >> gtIconName [
	^ #mooseMetamodelEntity
]

{ #category : #'*GToolkit4Famix3' }
FAMIXEntity >> gtLinksForFile: aFileReference do: aBlock [
	
]

{ #category : #'*GToolkit4Famix3' }
FAMIXEntity >> gtOpenApiPaths [
	<MSEProperty: #gtOpenApiPaths type: #GtOpenApiPath opposite: #implementers>
	<multivalued>
	^ self
		propertyNamed: #gtOpenApiPaths
		ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #implementers ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXEntity >> gtOpenApiPaths: aCollection [
	self gtOpenApiPaths value: aCollection
]
