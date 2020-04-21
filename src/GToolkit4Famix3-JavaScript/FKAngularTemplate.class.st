Class {
	#name : #FKAngularTemplate,
	#superclass : #FAMIXNamedEntity,
	#instVars : [
		'includedTemplates',
		'includingTemplates',
		'includedComponents',
		'includedTemplateUrls',
		'component',
		'isEmbedded'
	],
	#category : #'GToolkit4Famix3-JavaScript-Importer'
}

{ #category : #accessing }
FKAngularTemplate >> component [
	<MSEProperty: #component type: #FKAngularComponent opposite: #template> <derived>
	<MSEComment: 'this is the component associated with the template'>
	^ component
]

{ #category : #accessing }
FKAngularTemplate >> component: anObject [
	component := anObject
]

{ #category : #accessing }
FKAngularTemplate >> includedComponents [
	<MSEProperty: #includedComponents type: #FKAngularEmbeddableComponent opposite: #includingTemplates>
	^ includedComponents
]

{ #category : #accessing }
FKAngularTemplate >> includedComponents: anObject [
	includedComponents value: anObject
]

{ #category : #queries }
FKAngularTemplate >> includedComponentsAndTemplates [
	^ self includedComponents , self includedTemplates
]

{ #category : #accessing }
FKAngularTemplate >> includedTemplateUrls [
	| html |
	self sourceText isEmpty ifTrue: [ ^ {} ].
	html := Soup fromString: self sourceText.
	^ (html // 'ng-include') collect: [:each | (each attributeAt: 'src') pharoFromJSString ]
]

{ #category : #accessing }
FKAngularTemplate >> includedTemplates [
	<MSEProperty: #includedTemplates type: #FKAngularTemplate opposite: #includingTemplates>
	^ includedTemplates
]

{ #category : #accessing }
FKAngularTemplate >> includedTemplates: anObject [
	includedTemplates value: anObject
]

{ #category : #queries }
FKAngularTemplate >> includingComponentsAndTemplates [
	^ self includingTemplates, { self component }
]

{ #category : #accessing }
FKAngularTemplate >> includingTemplates [
	<MSEProperty: #includingTemplates type: #FKAngularTemplate opposite: #includedTemplates>
	^ includingTemplates
]

{ #category : #accessing }
FKAngularTemplate >> includingTemplates: anObject [
	includingTemplates value: anObject
]

{ #category : #initialize }
FKAngularTemplate >> initialize [
	super initialize.
	includedComponents := FMMultiMultivalueLink on: self opposite: #includingTemplates.
	includedTemplates := FMMultiMultivalueLink on: self opposite: #includingTemplates.
	includingTemplates := FMMultiMultivalueLink on: self opposite: #includedTemplates.
	isEmbedded := false
]

{ #category : #testing }
FKAngularTemplate >> isEmbedded [
	<MSEProperty: #isEmbedded type: #Boolean>
	^ isEmbedded
]

{ #category : #testing }
FKAngularTemplate >> isEmbedded: aBoolean [
	isEmbedded := aBoolean
]

{ #category : #queries }
FKAngularTemplate >> parentModule [
	^ self component 
		ifNotNil: [ self component parentModule ]
]
