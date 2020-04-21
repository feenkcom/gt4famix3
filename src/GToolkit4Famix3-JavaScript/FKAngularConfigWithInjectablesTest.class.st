Class {
	#name : #FKAngularConfigWithInjectablesTest,
	#superclass : #FKAngularImporterTest,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
FKAngularConfigWithInjectablesTest >> moduleA [
	^ 'angular.module(''moduleA'', [''moduleB''])
    .config(function ($routeProvider, ServiceY, ServiceZ) {});'
]

{ #category : #accessing }
FKAngularConfigWithInjectablesTest >> moduleB [
	^ 'angular.module(''moduleB'', []) //
    .factory(''ServiceY'', function () {})
	.factory(''ServiceZ'', function () {});'
]

{ #category : #accessing }
FKAngularConfigWithInjectablesTest >> samples [
	^ #(moduleA moduleB)
]

{ #category : #testing }
FKAngularConfigWithInjectablesTest >> testInjectables [
	self assert: importer targetModel allAngularInjectables size equals: 2
]

{ #category : #testing }
FKAngularConfigWithInjectablesTest >> testModuleA [
	| moduleA |
	moduleA := importer targetModel allAngularModules entityNamed: 'moduleA'.
	self assert: moduleA notNil.
	self assert: moduleA injectables size equals: 1.
	self assert: moduleA injectables anyOne fkJsAST notNil.
	self assert: moduleA injectables anyOne usedInjectables size equals: 2
]

{ #category : #testing }
FKAngularConfigWithInjectablesTest >> testModuleB [
	| moduleB |
	moduleB := importer targetModel allAngularModules entityNamed: 'moduleB'.
	self assert: moduleB notNil.
	self assert: moduleB injectables size equals: 2
]

{ #category : #testing }
FKAngularConfigWithInjectablesTest >> testModules [
	self assert: importer targetModel allAngularModules size equals: 2
]
