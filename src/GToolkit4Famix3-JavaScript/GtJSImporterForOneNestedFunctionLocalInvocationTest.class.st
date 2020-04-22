Class {
	#name : #GtJSImporterForOneNestedFunctionLocalInvocationTest,
	#superclass : #GtJavaScriptImporterTest,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
GtJSImporterForOneNestedFunctionLocalInvocationTest >> sample [
	^ 
'function root() {
	f(); 
	function f() {return 42;};
};'
]
