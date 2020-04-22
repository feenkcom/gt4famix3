Class {
	#name : #GtAngularConfigWithVarsTest,
	#superclass : #GtAngularImporterTest,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
GtAngularConfigWithVarsTest >> moduleA [
	^ 'angular.module(''moduleA'', [])
	.config(function ($routeProvider) {
		var missingPage = {
			templateUrl: ''template.html''
		};
});'
]

{ #category : #accessing }
GtAngularConfigWithVarsTest >> samples [
	^ #(moduleA)
]

{ #category : #testing }
GtAngularConfigWithVarsTest >> testModuleA [
	| moduleA |
	moduleA := importer targetModel allAngularModules entityNamed: 'moduleA'.
	self assert: moduleA components notEmpty.
	self assert: moduleA components anyOne name = '$routeProvider1'.
	self assert: moduleA components anyOne template name = 'template.html'
]

{ #category : #testing }
GtAngularConfigWithVarsTest >> testModules [
	self assert: importer targetModel allAngularModules size equals: 1
]
