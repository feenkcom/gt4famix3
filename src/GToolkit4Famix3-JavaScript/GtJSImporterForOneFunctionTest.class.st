Class {
	#name : #GtJSImporterForOneFunctionTest,
	#superclass : #GtJavaScriptImporterTest,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
GtJSImporterForOneFunctionTest >> sample [
	^ 'function a() {}'
]

{ #category : #testing }
GtJSImporterForOneFunctionTest >> testFunctionA [
	self assert: importer functions size equals: 1.
	self assert: importer functions anyOne name equals: 'a'
]
