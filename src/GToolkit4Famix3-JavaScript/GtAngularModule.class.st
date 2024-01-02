Class {
	#name : #GtAngularModule,
	#superclass : #FAMIXScopingEntity,
	#instVars : [
		'dependencies',
		'definingFiles',
		'dependentModules',
		'injectables',
		'components',
		'parentAppFileReference'
	],
	#category : #'GToolkit4Famix3-JavaScript-Importer'
}

{ #category : #'as yet unclassified' }
GtAngularModule class >> annotation [
	<MSEClass: #AngularModule super: #FAMIXNamedEntity>
	
]

{ #category : #accessing }
GtAngularModule >> addDefiningFile: aFile [
	^ definingFiles add: aFile
]

{ #category : #accessing }
GtAngularModule >> addDependencies: aCollection [
	self dependencies addAll: aCollection 
]

{ #category : #accessing }
GtAngularModule >> ast [
	^ self fkJsAST
]

{ #category : #accessing }
GtAngularModule >> ast: aJSCallExpressionNode [ 
	self fkJsAST: aJSCallExpressionNode
]

{ #category : #accessing }
GtAngularModule >> components [
	<MSEProperty: #components type: #GtAngularComponent" opposite: #parentModue"> <multivalued> <derived>
	^ components
]

{ #category : #accessing }
GtAngularModule >> components: aCollection [
	components value: aCollection
]

{ #category : #accessing }
GtAngularModule >> definingFile [
	^ definingFiles anyOne
]

{ #category : #accessing }
GtAngularModule >> definingFiles [
	^ definingFiles
]

{ #category : #accessing }
GtAngularModule >> dependencies [
	<MSEProperty: #dependencies type: #GtAngularModule opposite: #dependentModules> <multivalued>
	
	^ dependencies
]

{ #category : #accessing }
GtAngularModule >> dependencies: aCollection [
	dependencies value: aCollection
]

{ #category : #accessing }
GtAngularModule >> dependentModules [
	<MSEProperty: #dependentModules type: #GtAngularModule opposite: #dependencies> <multivalued> <derived>
	
	^ dependentModules
]

{ #category : #accessing }
GtAngularModule >> dependentModules: aCollection [	
	dependentModules value: aCollection
]

{ #category : #accessing }
GtAngularModule >> embeddableComponents [
	^ self components select: [ :each | each isEmbeddableComponent ]
]

{ #category : #ui }
GtAngularModule >> gtInspectorDefiningFileContentsIn: composite [
	<gtInspectorPresentationOrder: 40>
	self definingFiles isEmpty ifTrue: [ ^ self ].
	self definingFile gtInspectorContentsIn: composite
]

{ #category : #initialize }
GtAngularModule >> initialize [
	super initialize.
	dependencies := FMMultiMultivalueLink on: self opposite: #dependentModules.
	dependentModules := FMMultiMultivalueLink on: self opposite: #dependencies.
	definingFiles := OrderedCollection new.
	injectables := FMNullMultivalueLink on: self opposite: #parentModule: selector: #injectables.
	components := FMNullMultivalueLink on: self opposite: #parentModule: selector: #components.
]

{ #category : #accessing }
GtAngularModule >> injectables [
	<MSEProperty: #injectables type: #GtAngularInjectable opposite: #parentModule>
	^ injectables
]

{ #category : #accessing }
GtAngularModule >> parentAppFileReference [
	^ parentAppFileReference
]

{ #category : #accessing }
GtAngularModule >> parentAppFileReference: anObject [
	parentAppFileReference := anObject
]

{ #category : #accessing }
GtAngularModule >> rootName [
	^ 
	($. asParser negate star , $. asParser , $. asParser negate star) flatten /
	($. asParser negate star flatten)
		parse: self name
]

{ #category : #accessing }
GtAngularModule >> routeProviders [
	^ self components select: [ :each | each isRouteProvider ]
]
