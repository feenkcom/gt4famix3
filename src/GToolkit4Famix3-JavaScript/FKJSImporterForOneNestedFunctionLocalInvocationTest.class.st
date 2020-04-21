Class {
	#name : #FKJSImporterForOneNestedFunctionLocalInvocationTest,
	#superclass : #FKJavaScriptImporterTest,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
FKJSImporterForOneNestedFunctionLocalInvocationTest >> sample [
	^ 
'function root() {
	f(); 
	function f() {return 42;};
};'
]
