Class {
	#name : #GtAngularInjectable,
	#superclass : #FAMIXNamedEntity,
	#instVars : [
		'kind',
		'usedInjectables',
		'usedByInjectables',
		'parentModule'
	],
	#category : #'GToolkit4Famix3-JavaScript-Importer'
}

{ #category : #meta }
GtAngularInjectable class >> annotation [
	<MSEClass: #AngularInjectable super: #FAMIXNamedEntity>
]

{ #category : #accessing }
GtAngularInjectable >> addUsedInjectable: anInjectable [
	self usedInjectables add: anInjectable 
]

{ #category : #initialize }
GtAngularInjectable >> initialize [
	super initialize.
	usedByInjectables := FMMultiMultivalueLink on: self opposite: #usedInjectables.
	usedInjectables  := FMMultiMultivalueLink on: self opposite: #usedByInjectables.

]

{ #category : #accessing }
GtAngularInjectable >> kind [
	^ kind
]

{ #category : #accessing }
GtAngularInjectable >> kind: anObject [
	kind := anObject
]

{ #category : #'as yet unclassified' }
GtAngularInjectable >> mooseNameOn: stream [
	stream 
		nextPutAll: self name;
		nextPutAll: ' (';
		nextPutAll: self parentModule name;
		nextPut: $)
]

{ #category : #accessing }
GtAngularInjectable >> parentModule [
	<MSEProperty: #parentModule type: #GtAngularModule" opposite: #injectables">
	<container>
	^ parentModule
]

{ #category : #accessing }
GtAngularInjectable >> parentModule: aModule [
	parentModule := FMMultivalueLink 
		on: self
		update: #injectables
		from: self parentModule
		to: aModule
]

{ #category : #accessing }
GtAngularInjectable >> usedByInjectables [
	<MSEProperty: #usedByInjectables type: #GtAngularInjectable opposite: #usedInjectables>
	^ usedByInjectables
]

{ #category : #accessing }
GtAngularInjectable >> usedByInjectables: anObject [
	usedByInjectables value: anObject
]

{ #category : #accessing }
GtAngularInjectable >> usedInjectables [
	<MSEProperty: #usedInjectables type: #GtAngularInjectable opposite: #usedByInjectables>
	^ usedInjectables
]

{ #category : #accessing }
GtAngularInjectable >> usedInjectables: anObject [
	usedInjectables value: anObject
]
