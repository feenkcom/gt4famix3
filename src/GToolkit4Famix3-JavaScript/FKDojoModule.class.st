Class {
	#name : #FKDojoModule,
	#superclass : #FAMIXScopingEntity,
	#instVars : [
		'requiredModules',
		'dependentModules'
	],
	#category : #'GToolkit4Famix3-JavaScript-Dojo'
}

{ #category : #dependencies }
FKDojoModule >> addDependentModule: aFKDojoModule [
	self dependentModules add: aFKDojoModule
]

{ #category : #dependencies }
FKDojoModule >> addRequiredModule: aFKDojoModule [
	self requiredModules add: aFKDojoModule
]

{ #category : #accessing }
FKDojoModule >> dependentModules [
	<MSEProperty: #dependentModules type: #FKDojoModule opposite: #requiredModules> <multivalued>
	<MSEComment: 'Other modules that require this module'>
	^ dependentModules
]

{ #category : #accessing }
FKDojoModule >> dependentModules: anObject [
	dependentModules := anObject
]

{ #category : #'initialize-release' }
FKDojoModule >> initialize [
	super initialize.
	requiredModules := FMMultiMultivalueLink on: self opposite: #dependentModules.
	dependentModules := FMMultiMultivalueLink on: self opposite: #requiredModules
]

{ #category : #dependencies }
FKDojoModule >> removeDependentModule: aFKDojoModule [
	self dependentModules remove: aFKDojoModule
]

{ #category : #dependencies }
FKDojoModule >> removeRequiredModule: aFKDojoModule [
	self requiredModules remove: aFKDojoModule
]

{ #category : #accessing }
FKDojoModule >> requiredModules [
	<MSEProperty: #requiredModules type: #FKDojoModule opposite: #dependentModules> <multivalued>
	<MSEComment: 'Other modules that are required by this module'>
	^ requiredModules
]

{ #category : #accessing }
FKDojoModule >> requiredModules: anObject [
	requiredModules := anObject
]
