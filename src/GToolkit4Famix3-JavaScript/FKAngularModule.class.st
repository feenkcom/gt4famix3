Class {
	#name : #FKAngularModule,
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
FKAngularModule class >> annotation [
	<MSEClass: #AngularModule super: #FAMIXNamedEntity>
	
]

{ #category : #accessing }
FKAngularModule >> addDefiningFile: aFile [
	^ definingFiles add: aFile
]

{ #category : #accessing }
FKAngularModule >> addDependencies: aCollection [
	self dependencies addAll: aCollection 
]

{ #category : #accessing }
FKAngularModule >> ast [
	^ self fkJsAST
]

{ #category : #accessing }
FKAngularModule >> ast: aJSCallExpressionNode [ 
	self fkJsAST: aJSCallExpressionNode
]

{ #category : #accessing }
FKAngularModule >> components [
	<MSEProperty: #components type: #FKAngularComponent" opposite: #parentModue"> <multivalued> <derived>
	^ components
]

{ #category : #accessing }
FKAngularModule >> components: aCollection [
	components value: aCollection
]

{ #category : #accessing }
FKAngularModule >> definingFile [
	^ definingFiles anyOne
]

{ #category : #accessing }
FKAngularModule >> definingFiles [
	^ definingFiles
]

{ #category : #accessing }
FKAngularModule >> dependencies [
	<MSEProperty: #dependencies type: #FKAngularModule opposite: #dependentModules> <multivalued>
	
	^ dependencies
]

{ #category : #accessing }
FKAngularModule >> dependencies: aCollection [
	dependencies value: aCollection
]

{ #category : #accessing }
FKAngularModule >> dependentModules [
	<MSEProperty: #dependentModules type: #FKAngularModule opposite: #dependencies> <multivalued> <derived>
	
	^ dependentModules
]

{ #category : #accessing }
FKAngularModule >> dependentModules: aCollection [	
	dependentModules value: aCollection
]

{ #category : #accessing }
FKAngularModule >> embeddableComponents [
	^ self components select: [ :each | each isEmbeddableComponent ]
]

{ #category : #ui }
FKAngularModule >> gtInspectorDefiningFileContentsIn: composite [
	<gtInspectorPresentationOrder: 40>
	self definingFiles isEmpty ifTrue: [ ^ self ].
	self definingFile gtInspectorContentsIn: composite
]

{ #category : #ui }
FKAngularModule >> gtInspectorDependenciesModulesIn: composite [
	<gtInspectorPresentationOrder: 40>
	composite roassal2
		title: 'Dependencies';
		initializeView: [ RTMondrian new ];
		painting: [ :view |
			view shape label text: #name; if: [ :each | each = self  ] color: Color blue twiceLighter.
			view nodes: (self withDeepCollect: #dependencies).
			view edges connectToAll: #dependencies.
			view layout horizontalDominanceTree layered ]
]

{ #category : #ui }
FKAngularModule >> gtInspectorDependentModulesIn: composite [
	<gtInspectorPresentationOrder: 40>
	composite roassal2
		title: 'Dependents';
		initializeView: [ RTMondrian new ];
		painting: [ :view |
			view shape label text: #name; if: [ :each | each = self  ] color: Color blue twiceLighter.
			view nodes: (self withDeepCollect: #dependentModules).
			view edges connectFromAll: #dependentModules.
			view layout horizontalDominanceTree layered ]
]

{ #category : #initialize }
FKAngularModule >> initialize [
	super initialize.
	dependencies := FMMultiMultivalueLink on: self opposite: #dependentModules.
	dependentModules := FMMultiMultivalueLink on: self opposite: #dependencies.
	definingFiles := OrderedCollection new.
	injectables := FMNullMultivalueLink on: self opposite: #parentModule: selector: #injectables.
	components := FMNullMultivalueLink on: self opposite: #parentModule: selector: #components.
]

{ #category : #accessing }
FKAngularModule >> injectables [
	<MSEProperty: #injectables type: #FKAngularInjectable opposite: #parentModule>
	^ injectables
]

{ #category : #accessing }
FKAngularModule >> parentAppFileReference [
	^ parentAppFileReference
]

{ #category : #accessing }
FKAngularModule >> parentAppFileReference: anObject [
	parentAppFileReference := anObject
]

{ #category : #accessing }
FKAngularModule >> rootName [
	^ 
	($. asParser negate star , $. asParser , $. asParser negate star) flatten /
	($. asParser negate star flatten)
		parse: self name
]

{ #category : #accessing }
FKAngularModule >> routeProviders [
	^ self components select: [ :each | each isRouteProvider ]
]
