Extension { #name : #FAMIXAnnotationInstance }

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXAnnotationInstance >> gtJSwaggerEntity [
	<MSEProperty: #gtJSwaggerEntity
		type: #GtJSSwaggerEntity
		opposite: #annotationInstance>
	^ self privateState attributeAt: #gtJSwaggerEntity ifAbsent: [  ]
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
FAMIXAnnotationInstance >> gtJSwaggerEntity: anObject [
	self privateState attributeAt: #gtJSwaggerEntity put: anObject
]
