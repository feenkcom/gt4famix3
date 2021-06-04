"
This class contains tests

"
Class {
	#name : #GtJSImporterForOneFunctionInNamespaceWithExternalInvocationTest,
	#superclass : #GtJavaScriptImporterTest,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
GtJSImporterForOneFunctionInNamespaceWithExternalInvocationTest >> sample [
	^ 
'var x = (function xDefinition(){ 
	function f() {return 42;} 
	return { f: f }; }());
x.f();'
]
