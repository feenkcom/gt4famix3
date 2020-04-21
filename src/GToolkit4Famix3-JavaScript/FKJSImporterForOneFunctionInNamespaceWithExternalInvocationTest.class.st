Class {
	#name : #FKJSImporterForOneFunctionInNamespaceWithExternalInvocationTest,
	#superclass : #FKJavaScriptImporterTest,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
FKJSImporterForOneFunctionInNamespaceWithExternalInvocationTest >> sample [
	^ 
'var x = (function xDefinition(){ 
	function f() {return 42;} 
	return { f: f }; }());
x.f();'
]
