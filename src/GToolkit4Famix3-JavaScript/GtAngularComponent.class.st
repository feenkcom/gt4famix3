Class {
	#name : #GtAngularComponent,
	#superclass : #FAMIXNamedEntity,
	#instVars : [
		'parentModule',
		'templateUrl',
		'includingTemplates',
		'template'
	],
	#category : #'GToolkit4Famix3-JavaScript-Importer'
}

{ #category : #meta }
GtAngularComponent class >> annotation [
	<MSEClass: #AngularComponent super: #FAMIXNamedEntity>
	
]

{ #category : #accessing }
GtAngularComponent >> ast [
	^ self fkJsAST
]

{ #category : #accessing }
GtAngularComponent >> ast: aJSCallExpressionNode [ 
	self fkJsAST: aJSCallExpressionNode
]

{ #category : #testing }
GtAngularComponent >> hasTemplate [
	^ template notNil
]

{ #category : #accessing }
GtAngularComponent >> htmlName [
	| upper camelCase |
	upper := ($A to: $Z) asParser.
	camelCase := upper negate star flatten , (upper, upper negate star flatten  ==> [:t | t first asString, t second]) star ==> [:t | Array with: t first withAll: t second].
	^ ('-' join: (camelCase end parse: self name)) asLowercase
]

{ #category : #queries }
GtAngularComponent >> includedComponentsAndTemplates [
	^ template ifNil: [{}] ifNotNil: [{ template }]
]

{ #category : #queries }
GtAngularComponent >> includingComponentsAndTemplates [
	^ self includingTemplates
]

{ #category : #accessing }
GtAngularComponent >> includingTemplates [
	<MSEProperty: #includingTemplates type: #GtAngularTemplate opposite: #includedComponents>
	^ includingTemplates
]

{ #category : #accessing }
GtAngularComponent >> includingTemplates: anObject [
	includingTemplates := anObject
]

{ #category : #initialize }
GtAngularComponent >> initialize [
	super initialize.
	includingTemplates := FMMultiMultivalueLink on: self opposite: #includedComponents
]

{ #category : #testing }
GtAngularComponent >> isEmbeddableComponent [
	^ false
]

{ #category : #testing }
GtAngularComponent >> isRouteProvider [
	^ false
]

{ #category : #printing }
GtAngularComponent >> mooseNameOn: stream [
	stream 
		nextPutAll: self htmlName;
		nextPutAll: ' | ';
		nextPutAll: self name;
		nextPutAll: ' ('.
	self parentModule mooseNameOn: stream.
	stream nextPutAll: ')'
]

{ #category : #accessing }
GtAngularComponent >> parentModule [
	<MSEProperty: #parentModule type: #GtAngularModule "opposite: #components">
	<container>
	^ parentModule
]

{ #category : #accessing }
GtAngularComponent >> parentModule: aModule [
	parentModule := FMMultivalueLink 
		on: self
		update: #components
		from: self parentModule
		to: aModule
]

{ #category : #accessing }
GtAngularComponent >> template [
	<MSEProperty: #template type: #GtAngularTemplate opposite: #component> <derived>
	^ template
]

{ #category : #accessing }
GtAngularComponent >> template: anObject [
	template := anObject
]

{ #category : #accessing }
GtAngularComponent >> templateFileReference [
	^ self sourceAnchor fileReference parent resolve: self templateUrl
]

{ #category : #accessing }
GtAngularComponent >> templateUrl [
	^ templateUrl
]

{ #category : #accessing }
GtAngularComponent >> templateUrl: anObject [
	templateUrl := anObject
]
