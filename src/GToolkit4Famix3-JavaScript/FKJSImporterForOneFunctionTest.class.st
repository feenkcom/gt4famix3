Class {
	#name : #FKJSImporterForOneFunctionTest,
	#superclass : #FKJavaScriptImporterTest,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
FKJSImporterForOneFunctionTest >> sample [
	^ 'function a() {}'
]

{ #category : #testing }
FKJSImporterForOneFunctionTest >> testFunctionA [
	self assert: importer functions size equals: 1.
	self assert: importer functions anyOne name equals: 'a'
]
