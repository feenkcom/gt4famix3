Class {
	#name : #GtJSScript,
	#superclass : #FAMIXBehaviouralEntity,
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
