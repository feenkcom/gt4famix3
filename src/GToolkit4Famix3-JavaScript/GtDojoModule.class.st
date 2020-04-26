Class {
	#name : #GtDojoModule,
	#superclass : #FAMIXScopingEntity,
	#instVars : [
		'requiredModules',
		'dependentModules'
	],
	#category : #'GToolkit4Famix3-JavaScript-Dojo'
}

{ #category : #dependencies }
GtDojoModule >> addDependentModule: aFKDojoModule [
	self dependentModules add: aFKDojoModule
]

{ #category : #dependencies }
GtDojoModule >> addRequiredModule: aFKDojoModule [
	self requiredModules add: aFKDojoModule
]

{ #category : #accessing }
GtDojoModule >> dependentModules [
	<MSEProperty: #dependentModules type: #GtDojoModule opposite: #requiredModules> <multivalued>
	<MSEComment: 'Other modules that require this module'>
	^ dependentModules
]

{ #category : #accessing }
GtDojoModule >> dependentModules: anObject [
	dependentModules := anObject
]

{ #category : #'initialize-release' }
GtDojoModule >> initialize [
	super initialize.
	requiredModules := FMMultiMultivalueLink on: self opposite: #dependentModules.
	dependentModules := FMMultiMultivalueLink on: self opposite: #requiredModules
]

{ #category : #dependencies }
GtDojoModule >> removeDependentModule: aFKDojoModule [
	self dependentModules remove: aFKDojoModule
]

{ #category : #dependencies }
GtDojoModule >> removeRequiredModule: aFKDojoModule [
	self requiredModules remove: aFKDojoModule
]

{ #category : #accessing }
GtDojoModule >> requiredModules [
	<MSEProperty: #requiredModules type: #GtDojoModule opposite: #dependentModules> <multivalued>
	<MSEComment: 'Other modules that are required by this module'>
	^ requiredModules
]

{ #category : #accessing }
GtDojoModule >> requiredModules: anObject [
	requiredModules := anObject
]
