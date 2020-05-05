Class {
	#name : #GtJSModule,
	#superclass : #FAMIXFile,
	#instVars : [
		'script',
		'imports',
		'exports'
	],
	#category : #'GToolkit4Famix3-JavaScript-Model'
}

{ #category : #accessing }
GtJSModule >> exports [
	<MSEProperty: #exports type: #GtJSImport opposite: #target>
	<multivalued>
	^ exports
]

{ #category : #accessing }
GtJSModule >> exports: aCollection [
	exports value: aCollection
]

{ #category : #accessing }
GtJSModule >> imports [
	<MSEProperty: #imports type: #GtJSImport opposite: #source>
	<multivalued>
	^ imports
]

{ #category : #accessing }
GtJSModule >> imports: aCollection [
	imports value: aCollection
]

{ #category : #accessing }
GtJSModule >> initialize [
	super initialize.
	imports := FMNullMultivalueLink
		on: self
		opposite: #source:
		selector: #imports.
	exports := FMNullMultivalueLink
		on: self
		opposite: #target:
		selector: #exports
]

{ #category : #accessing }
GtJSModule >> script [
	<MSEProperty: #script type: #GtJSScript opposite: #module>
	^ script
]

{ #category : #accessing }
GtJSModule >> script: aJSScript [
	script := aJSScript
]
