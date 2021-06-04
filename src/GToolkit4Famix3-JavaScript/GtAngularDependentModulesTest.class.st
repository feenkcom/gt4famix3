"
This class contains tests

"
Class {
	#name : #GtAngularDependentModulesTest,
	#superclass : #GtAngularImporterTest,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
GtAngularDependentModulesTest >> moduleA [
	^ 'angular.module(''moduleA'', [''moduleB'']) //
    .factory(''ServiceX'', function (ServiceY, ServiceZ) {});'
]

{ #category : #accessing }
GtAngularDependentModulesTest >> moduleB [
	^ 'angular.module(''moduleB'', []) //
    .factory(''ServiceY'', function () {})
	.factory(''ServiceZ'', function () {});'
]

{ #category : #accessing }
GtAngularDependentModulesTest >> samples [
	^ #(moduleA moduleB)
]

{ #category : #testing }
GtAngularDependentModulesTest >> testInjectables [
	self assert: importer targetModel allAngularInjectables size equals: 3
]

{ #category : #testing }
GtAngularDependentModulesTest >> testModuleA [
	| moduleA |
	moduleA := importer targetModel allAngularModules entityNamed: 'moduleA'.
	self assert: moduleA notNil.
	self assert: moduleA injectables size equals: 1.
	self assert: moduleA injectables anyOne fkJsAST notNil.
	self assert: moduleA injectables anyOne usedInjectables size equals: 2
]

{ #category : #testing }
GtAngularDependentModulesTest >> testModuleB [
	| moduleB |
	moduleB := importer targetModel allAngularModules entityNamed: 'moduleB'.
	self assert: moduleB notNil.
	self assert: moduleB injectables size equals: 2
]

{ #category : #testing }
GtAngularDependentModulesTest >> testModules [
	self assert: importer targetModel allAngularModules size equals: 2
]
