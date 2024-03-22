Extension { #name : #MooseModel }

{ #category : #'*GToolkit4Famix3-Java' }
MooseModel >> allGtJavaSpringCalls [
	<navigation: 'All Java Spring Calls'>
	^ GtJavaSpringCallGroup withAll: (self allWithType: GtJavaSpringCall)
]

{ #category : #'*GToolkit4Famix3-Java' }
MooseModel >> allGtJavaSpringMappings [
	<navigation: 'All Spring Mappings'>
	^ GtJavaSpringMappingGroup withAll: (self allWithType: GtJavaSpringMapping)
]

{ #category : #'*GToolkit4Famix3-Java' }
MooseModel >> allGtJavaSpringRestControllers [
	<navigation: 'All Spring Rest Controllers'>
	^ self allWithType: GtJavaSpringRestController
]

{ #category : #'*GToolkit4Famix3-Java' }
MooseModel >> allNonJUnitGtJavaSpringCalls [
	<navigation: 'All Non JUnit Java Spring Calls'>
	^ (GtJavaSpringCallGroup withAll: (self allWithType: GtJavaSpringCall))
		reject: [ :each | each from isMethod and: [ each from isJUnit4Test ] ]
]
