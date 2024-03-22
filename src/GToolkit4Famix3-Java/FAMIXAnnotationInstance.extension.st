Extension { #name : #FAMIXAnnotationInstance }

{ #category : #'*GToolkit4Famix3-Java' }
FAMIXAnnotationInstance >> gtJavaSpringEntity [
	<MSEProperty: #gtJavaSpringEntity
		type: #GtJavaSpringEntity
		opposite: #annotationInstance>
	^ self privateState attributeAt: #gtJavaSpringEntity ifAbsent: [  ]
]

{ #category : #'*GToolkit4Famix3-Java' }
FAMIXAnnotationInstance >> gtJavaSpringEntity: aMapping [
	self privateState attributeAt: #gtJavaSpringEntity put: aMapping
]

{ #category : #'*GToolkit4Famix3-Java' }
FAMIXAnnotationInstance >> gtJavaSpringMapping [
	<MSEProperty: #gtJavaSpringMapping
		type: #GtJavaSpringMapping
		opposite: #annotationInstance>
	^ self privateState attributeAt: #gtJavaSpringMapping ifAbsent: [  ]
]

{ #category : #'*GToolkit4Famix3-Java' }
FAMIXAnnotationInstance >> gtJavaSpringMapping: aMapping [
	self privateState attributeAt: #gtJavaSpringMapping put: aMapping
]
