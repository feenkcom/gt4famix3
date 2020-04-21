Class {
	#name : #FKAngularBasicModuleTest,
	#superclass : #FKAngularImporterTest,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
FKAngularBasicModuleTest >> module [
	^ 'angular.module(''moduleA'', []) //
    .factory(''ServiceX'', function (ServiceY, ServiceZ) {});'
]

{ #category : #accessing }
FKAngularBasicModuleTest >> samples [
	^ #(module)
]

{ #category : #testing }
FKAngularBasicModuleTest >> testModule [
	self assert: importer targetModel allAngularModules size equals: 1
]
