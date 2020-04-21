Class {
	#name : #FKAngularComponent,
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
FKAngularComponent class >> annotation [
	<MSEClass: #AngularComponent super: #FAMIXNamedEntity>
	
]

{ #category : #accessing }
FKAngularComponent >> ast [
	^ self fkJsAST
]

{ #category : #accessing }
FKAngularComponent >> ast: aJSCallExpressionNode [ 
	self fkJsAST: aJSCallExpressionNode
]

{ #category : #testing }
FKAngularComponent >> hasTemplate [
	^ template notNil
]

{ #category : #accessing }
FKAngularComponent >> htmlName [
	| upper camelCase |
	upper := ($A to: $Z) asParser.
	camelCase := upper negate star flatten , (upper, upper negate star flatten  ==> [:t | t first asString, t second]) star ==> [:t | Array with: t first withAll: t second].
	^ ('-' join: (camelCase end parse: self name)) asLowercase
]

{ #category : #queries }
FKAngularComponent >> includedComponentsAndTemplates [
	^ template ifNil: [{}] ifNotNil: [{ template }]
]

{ #category : #queries }
FKAngularComponent >> includingComponentsAndTemplates [
	^ self includingTemplates
]

{ #category : #accessing }
FKAngularComponent >> includingTemplates [
	<MSEProperty: #includingTemplates type: #FKAngularTemplate opposite: #includedComponents>
	^ includingTemplates
]

{ #category : #accessing }
FKAngularComponent >> includingTemplates: anObject [
	includingTemplates := anObject
]

{ #category : #initialize }
FKAngularComponent >> initialize [
	super initialize.
	includingTemplates := FMMultiMultivalueLink on: self opposite: #includedComponents
]

{ #category : #testing }
FKAngularComponent >> isEmbeddableComponent [
	^ false
]

{ #category : #testing }
FKAngularComponent >> isRouteProvider [
	^ false
]

{ #category : #printing }
FKAngularComponent >> mooseNameOn: stream [
	stream 
		nextPutAll: self htmlName;
		nextPutAll: ' | ';
		nextPutAll: self name;
		nextPutAll: ' ('.
	self parentModule mooseNameOn: stream.
	stream nextPutAll: ')'
]

{ #category : #accessing }
FKAngularComponent >> parentModule [
	<MSEProperty: #parentModule type: #FKAngularModule "opposite: #components">
	<container>
	^ parentModule
]

{ #category : #accessing }
FKAngularComponent >> parentModule: aModule [
	parentModule := FMMultivalueLink 
		on: self
		update: #components
		from: self parentModule
		to: aModule
]

{ #category : #accessing }
FKAngularComponent >> template [
	<MSEProperty: #template type: #FKAngularTemplate opposite: #component> <derived>
	^ template
]

{ #category : #accessing }
FKAngularComponent >> template: anObject [
	template := anObject
]

{ #category : #accessing }
FKAngularComponent >> templateFileReference [
	^ self sourceAnchor fileReference parent resolve: self templateUrl
]

{ #category : #accessing }
FKAngularComponent >> templateUrl [
	^ templateUrl
]

{ #category : #accessing }
FKAngularComponent >> templateUrl: anObject [
	templateUrl := anObject
]
