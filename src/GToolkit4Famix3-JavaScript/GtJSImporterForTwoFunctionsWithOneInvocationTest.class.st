"
This class contains tests

"
Class {
	#name : #GtJSImporterForTwoFunctionsWithOneInvocationTest,
	#superclass : #GtJavaScriptImporterTest,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
GtJSImporterForTwoFunctionsWithOneInvocationTest >> sample [
	^ 
'function a() {b();}
function b() {}
'
]

{ #category : #testing }
GtJSImporterForTwoFunctionsWithOneInvocationTest >> testFunctionA [
	| a |
	a := importer model allFunctions detect: [ :each | each name = 'a' ].
	self assert: a outgoingInvocations size equals: 1
]

{ #category : #testing }
GtJSImporterForTwoFunctionsWithOneInvocationTest >> testFunctions [
	self assert: importer model allFunctions size equals: 2
]
