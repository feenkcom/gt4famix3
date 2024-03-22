Extension { #name : #MooseModel }

{ #category : #'*GToolkit4Famix3-JavaScript' }
MooseModel >> allAngularComponents [

]

{ #category : #'*GToolkit4Famix3-JavaScript' }
MooseModel >> allAngularInjectables [
	<navigation: 'All Angular injectables'>
	^ self allWithType: GtAngularInjectable
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
MooseModel >> allAngularModules [
	<navigation: 'All Angular modules'>
	^ self allWithType: GtAngularModule
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
MooseModel >> allAngularTemplates [
	<navigation: 'All Angular templates'>
	^ self allWithType: GtAngularTemplate
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
MooseModel >> allGtJSSwaggerCalls [
	<navigation: 'All Swagger Calls'>
	^ GtJSSwaggerCallGroup withAll: (self allWithType: GtJSSwaggerCall)
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
MooseModel >> allGtJSSwaggerHandlers [
	<navigation: 'All Swagger Handlers'>
	^ self allWithType: GtJSSwaggerHandler
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
MooseModel >> allJSInvocations [
	^ self allWithType: GtJSInvocation
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
MooseModel >> spotterAngularComponentsFor: aStep [
	<spotterOrder: 30>
	self spotter: 'All angular components' on: [ self allAngularComponents ] for: aStep
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
MooseModel >> spotterAngularInjectablesFor: aStep [
	<spotterOrder: 20>
	self spotter: 'All angular injectables' on: [ self allAngularInjectables ] for: aStep
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
MooseModel >> spotterAngularModulesFor: aStep [
	<spotterOrder: 10>
	self spotter: 'All angular modules' on: [ self allAngularModules ] for: aStep
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
MooseModel >> spotterAngularTemplatesFor: aStep [
	<spotterOrder: 40>
	self spotter: 'All angular templates' on: [ self allAngularTemplates ] for: aStep
]
