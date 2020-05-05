Class {
	#name : #GtJSImport,
	#superclass : #FAMIXAssociation,
	#instVars : [
		'source',
		'target'
	],
	#category : #'GToolkit4Famix3-JavaScript-Model'
}

{ #category : #accessing }
GtJSImport >> from [	
	^ self source
]

{ #category : #accessing }
GtJSImport >> source [
	<MSEProperty: #source type: #GtJSModule opposite: #imports>
	^ source
]

{ #category : #accessing }
GtJSImport >> source: aJSScript [
	source := FMMultivalueLink
		on: self
		update: #imports
		from: self source
		to: aJSScript
]

{ #category : #accessing }
GtJSImport >> target [
	<MSEProperty: #target type: #GtJSModule opposite: #exports>
	^ target
]

{ #category : #accessing }
GtJSImport >> target: aJSScript [
	target := FMMultivalueLink
		on: self
		update: #exports
		from: self target
		to: aJSScript
]

{ #category : #accessing }
GtJSImport >> to [
	^ self target
]
