Class {
	#name : #FKDojoClass,
	#superclass : #FAMIXClass,
	#category : #'GToolkit4Famix3-JavaScript-Dojo'
}

{ #category : #accessing }
FKDojoClass >> isWidget [
	^ self privateState attributeAt: #isWidget ifAbsent: [ false ]
]

{ #category : #accessing }
FKDojoClass >> isWidget: aBoolean [
	^ self privateState attributeAt: #isWidget put: aBoolean
]

{ #category : #accessing }
FKDojoClass >> template [
	^ self privateState attributeAt: #template ifAbsent: [ nil ]
]

{ #category : #accessing }
FKDojoClass >> template: aString [
	^ self privateState attributeAt: #template put: aString
]
