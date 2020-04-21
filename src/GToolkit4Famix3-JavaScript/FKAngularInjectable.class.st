Class {
	#name : #FKAngularInjectable,
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
FKAngularInjectable class >> annotation [
	<MSEClass: #AngularInjectable super: #FAMIXNamedEntity>
]

{ #category : #accessing }
FKAngularInjectable >> addUsedInjectable: anInjectable [
	self usedInjectables add: anInjectable 
]

{ #category : #initialize }
FKAngularInjectable >> initialize [
	super initialize.
	usedByInjectables := FMMultiMultivalueLink on: self opposite: #usedInjectables.
	usedInjectables  := FMMultiMultivalueLink on: self opposite: #usedByInjectables.

]

{ #category : #accessing }
FKAngularInjectable >> kind [
	^ kind
]

{ #category : #accessing }
FKAngularInjectable >> kind: anObject [
	kind := anObject
]

{ #category : #'as yet unclassified' }
FKAngularInjectable >> mooseNameOn: stream [
	stream 
		nextPutAll: self name;
		nextPutAll: ' (';
		nextPutAll: self parentModule name;
		nextPut: $)
]

{ #category : #accessing }
FKAngularInjectable >> parentModule [
	<MSEProperty: #parentModule type: #FKAngularModule" opposite: #injectables">
	<container>
	^ parentModule
]

{ #category : #accessing }
FKAngularInjectable >> parentModule: aModule [
	parentModule := FMMultivalueLink 
		on: self
		update: #injectables
		from: self parentModule
		to: aModule
]

{ #category : #accessing }
FKAngularInjectable >> usedByInjectables [
	<MSEProperty: #usedByInjectables type: #FKAngularInjectable opposite: #usedInjectables>
	^ usedByInjectables
]

{ #category : #accessing }
FKAngularInjectable >> usedByInjectables: anObject [
	usedByInjectables value: anObject
]

{ #category : #accessing }
FKAngularInjectable >> usedInjectables [
	<MSEProperty: #usedInjectables type: #FKAngularInjectable opposite: #usedByInjectables>
	^ usedInjectables
]

{ #category : #accessing }
FKAngularInjectable >> usedInjectables: anObject [
	usedInjectables value: anObject
]
