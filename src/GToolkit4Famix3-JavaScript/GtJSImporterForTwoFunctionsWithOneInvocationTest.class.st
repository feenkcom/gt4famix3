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
	a := importer functions at: 'a'.
	self assert: a outgoingInvocations size equals: 1
]

{ #category : #testing }
GtJSImporterForTwoFunctionsWithOneInvocationTest >> testFunctions [
	self assert: importer functions size equals: 2.
]
