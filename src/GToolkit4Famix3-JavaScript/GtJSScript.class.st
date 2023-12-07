Class {
	#name : #GtJSScript,
	#superclass : #FAMIXBehaviouralEntity,
	#instVars : [
		'module'
	],
	#category : #'GToolkit4Famix3-JavaScript-Model'
}

{ #category : #meta }
GtJSScript class >> annotation [
	<MSEClass: #JScript super: #FAMIXBehaviouralEntity>
	<package: #FAMIX>
]

{ #category : #testing }
GtJSScript >> isJSScript [
	^ true
]

{ #category : #accessing }
GtJSScript >> module [
	<MSEProperty: #module type: #GtJSModule opposite: #script>
	^ module
]

{ #category : #accessing }
GtJSScript >> module: aJSModule [
	module := aJSModule
]

{ #category : #accessing }
GtJSScript >> parentScope [
	^ nil
]
