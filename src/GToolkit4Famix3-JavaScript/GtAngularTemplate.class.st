Class {
	#name : #GtAngularTemplate,
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
GtAngularTemplate >> component [
	<MSEProperty: #component type: #GtAngularComponent opposite: #template> <derived>
	<MSEComment: 'this is the component associated with the template'>
	^ component
]

{ #category : #accessing }
GtAngularTemplate >> component: anObject [
	component := anObject
]

{ #category : #accessing }
GtAngularTemplate >> includedComponents [
	<MSEProperty: #includedComponents type: #GtAngularEmbeddableComponent opposite: #includingTemplates>
	^ includedComponents
]

{ #category : #accessing }
GtAngularTemplate >> includedComponents: anObject [
	includedComponents value: anObject
]

{ #category : #queries }
GtAngularTemplate >> includedComponentsAndTemplates [
	^ self includedComponents , self includedTemplates
]

{ #category : #accessing }
GtAngularTemplate >> includedTemplateUrls [
	| html |
	self sourceText isEmpty ifTrue: [ ^ {} ].
	html := Soup fromString: self sourceText.
	^ (html // 'ng-include') collect: [:each | (each attributeAt: 'src') pharoFromJSString ]
]

{ #category : #accessing }
GtAngularTemplate >> includedTemplates [
	<MSEProperty: #includedTemplates type: #GtAngularTemplate opposite: #includingTemplates>
	^ includedTemplates
]

{ #category : #accessing }
GtAngularTemplate >> includedTemplates: anObject [
	includedTemplates value: anObject
]

{ #category : #queries }
GtAngularTemplate >> includingComponentsAndTemplates [
	^ self includingTemplates, { self component }
]

{ #category : #accessing }
GtAngularTemplate >> includingTemplates [
	<MSEProperty: #includingTemplates type: #GtAngularTemplate opposite: #includedTemplates>
	^ includingTemplates
]

{ #category : #accessing }
GtAngularTemplate >> includingTemplates: anObject [
	includingTemplates value: anObject
]

{ #category : #initialize }
GtAngularTemplate >> initialize [
	super initialize.
	includedComponents := FMMultiMultivalueLink on: self opposite: #includingTemplates.
	includedTemplates := FMMultiMultivalueLink on: self opposite: #includingTemplates.
	includingTemplates := FMMultiMultivalueLink on: self opposite: #includedTemplates.
	isEmbedded := false
]

{ #category : #testing }
GtAngularTemplate >> isEmbedded [
	<MSEProperty: #isEmbedded type: #Boolean>
	^ isEmbedded
]

{ #category : #testing }
GtAngularTemplate >> isEmbedded: aBoolean [
	isEmbedded := aBoolean
]

{ #category : #queries }
GtAngularTemplate >> parentModule [
	^ self component 
		ifNotNil: [ self component parentModule ]
]
