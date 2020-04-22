Class {
	#name : #GtJSScript,
	#superclass : #FAMIXBehaviouralEntity,
	#category : #'GToolkit4Famix3-JavaScript-Dojo'
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
