Class {
	#name : #GtDojoClass,
	#superclass : #FAMIXClass,
	#category : #'GToolkit4Famix3-JavaScript-Dojo'
}

{ #category : #accessing }
GtDojoClass >> isWidget [
	^ self privateState attributeAt: #isWidget ifAbsent: [ false ]
]

{ #category : #accessing }
GtDojoClass >> isWidget: aBoolean [
	^ self privateState attributeAt: #isWidget put: aBoolean
]

{ #category : #accessing }
GtDojoClass >> template [
	^ self privateState attributeAt: #template ifAbsent: [ nil ]
]

{ #category : #accessing }
GtDojoClass >> template: aString [
	^ self privateState attributeAt: #template put: aString
]
