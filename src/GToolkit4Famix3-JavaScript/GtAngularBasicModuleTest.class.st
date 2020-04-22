Class {
	#name : #GtAngularBasicModuleTest,
	#superclass : #GtAngularImporterTest,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
GtAngularBasicModuleTest >> module [
	^ 'angular.module(''moduleA'', []) //
    .factory(''ServiceX'', function (ServiceY, ServiceZ) {});'
]

{ #category : #accessing }
GtAngularBasicModuleTest >> samples [
	^ #(module)
]

{ #category : #testing }
GtAngularBasicModuleTest >> testModule [
	self assert: importer targetModel allAngularModules size equals: 1
]
