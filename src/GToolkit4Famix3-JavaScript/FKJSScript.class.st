Class {
	#name : #FKJSScript,
	#superclass : #FAMIXBehaviouralEntity,
	#category : #'GToolkit4Famix3-JavaScript-Dojo'
}

{ #category : #meta }
FKJSScript class >> annotation [
	<MSEClass: #JScript super: #FAMIXBehaviouralEntity>
	<package: #FAMIX>
]

{ #category : #testing }
FKJSScript >> isJSScript [
	^ true
]
