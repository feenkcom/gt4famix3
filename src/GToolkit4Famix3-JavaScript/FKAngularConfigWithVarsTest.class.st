Class {
	#name : #FKAngularConfigWithVarsTest,
	#superclass : #FKAngularImporterTest,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
FKAngularConfigWithVarsTest >> moduleA [
	^ 'angular.module(''moduleA'', [])
	.config(function ($routeProvider) {
		var missingPage = {
			templateUrl: ''template.html''
		};
});'
]

{ #category : #accessing }
FKAngularConfigWithVarsTest >> samples [
	^ #(moduleA)
]

{ #category : #testing }
FKAngularConfigWithVarsTest >> testModuleA [
	| moduleA |
	moduleA := importer targetModel allAngularModules entityNamed: 'moduleA'.
	self assert: moduleA components notEmpty.
	self assert: moduleA components anyOne name = '$routeProvider1'.
	self assert: moduleA components anyOne template name = 'template.html'
]

{ #category : #testing }
FKAngularConfigWithVarsTest >> testModules [
	self assert: importer targetModel allAngularModules size equals: 1
]
