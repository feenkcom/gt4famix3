Class {
	#name : #GtAngularConfigWithInjectablesTest,
	#superclass : #GtAngularImporterTest,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
GtAngularConfigWithInjectablesTest >> moduleA [
	^ 'angular.module(''moduleA'', [''moduleB''])
    .config(function ($routeProvider, ServiceY, ServiceZ) {});'
]

{ #category : #accessing }
GtAngularConfigWithInjectablesTest >> moduleB [
	^ 'angular.module(''moduleB'', []) //
    .factory(''ServiceY'', function () {})
	.factory(''ServiceZ'', function () {});'
]

{ #category : #accessing }
GtAngularConfigWithInjectablesTest >> samples [
	^ #(moduleA moduleB)
]

{ #category : #testing }
GtAngularConfigWithInjectablesTest >> testInjectables [
	self assert: importer targetModel allAngularInjectables size equals: 2
]

{ #category : #testing }
GtAngularConfigWithInjectablesTest >> testModuleA [
	| moduleA |
	moduleA := importer targetModel allAngularModules entityNamed: 'moduleA'.
	self assert: moduleA notNil.
	self assert: moduleA injectables size equals: 1.
	self assert: moduleA injectables anyOne fkJsAST notNil.
	self assert: moduleA injectables anyOne usedInjectables size equals: 2
]

{ #category : #testing }
GtAngularConfigWithInjectablesTest >> testModuleB [
	| moduleB |
	moduleB := importer targetModel allAngularModules entityNamed: 'moduleB'.
	self assert: moduleB notNil.
	self assert: moduleB injectables size equals: 2
]

{ #category : #testing }
GtAngularConfigWithInjectablesTest >> testModules [
	self assert: importer targetModel allAngularModules size equals: 2
]
