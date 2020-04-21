Class {
	#name : #FKJSImportOneObjectTest,
	#superclass : #FKJavaScriptImporterTest,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
FKJSImportOneObjectTest >> sample [
	^ 'var object = {property1: "string", property2: 42, 3: "three"}'
]
