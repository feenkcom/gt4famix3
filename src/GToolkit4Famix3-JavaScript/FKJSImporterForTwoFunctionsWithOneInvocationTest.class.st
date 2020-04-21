Class {
	#name : #FKJSImporterForTwoFunctionsWithOneInvocationTest,
	#superclass : #FKJavaScriptImporterTest,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
FKJSImporterForTwoFunctionsWithOneInvocationTest >> sample [
	^ 
'function a() {b();}
function b() {}
'
]

{ #category : #testing }
FKJSImporterForTwoFunctionsWithOneInvocationTest >> testFunctionA [
	| a |
	a := importer functions at: 'a'.
	self assert: a outgoingInvocations size equals: 1
]

{ #category : #testing }
FKJSImporterForTwoFunctionsWithOneInvocationTest >> testFunctions [
	self assert: importer functions size equals: 2.
]
