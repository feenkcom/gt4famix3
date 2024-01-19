Class {
	#name : #GtDojoImporterExamples,
	#superclass : #GtImporterExamples,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #'example-tests' }
GtDojoImporterExamples >> comments [
	<gtExample>
	| importer script |
	importer := self exampleImporter.
	script := importer scriptNamed: 'demo/noModule.js'.
	self assert: script comments size = 2.
	^ script comments
]

{ #category : #private }
GtDojoImporterExamples >> countOf: aCollection inside: aFKJSScript [
	^ aCollection
		inject: 0
		into: [ :sum :each | 
			sum
				+
					((each allParents includes: aFKJSScript)
						ifTrue: [ 1 ]
						ifFalse: [ 0 ]) ]
]

{ #category : #private }
GtDojoImporterExamples >> countOfReaders: aVariable [
	^ (aVariable incomingAccesses select: #isRead) size
]

{ #category : #private }
GtDojoImporterExamples >> countOfWriters: aVariable [
	^ (aVariable incomingAccesses select: #isWrite) size
]

{ #category : #files }
GtDojoImporterExamples >> demo_dojoClassWithSuperclass_js [
	^ 'define([''dojo/_base/declare'', ''demo/dojoClassWithoutSuperclass''], function(declare, spr) { return declare(spr, { f : function() { return this.attr } })})'
]

{ #category : #files }
GtDojoImporterExamples >> demo_dojoClassWithoutSuperclass_js [
	^ 'define([''dojo/_base/declare''], function(declare) { return declare([], { attr : 1 })})'
]

{ #category : #files }
GtDojoImporterExamples >> demo_dojoNamedClass_js [
	^ 'define([''dojo/_base/declare'', ''demo/dojoClassWithSuperclass''], function(declare, spr) { return declare("demo/dojoNamedClass", [spr], { attr2 : 2 })})'
]

{ #category : #files }
GtDojoImporterExamples >> demo_invocations_js [
	^ '
var o = { a : function() {  return 7 } };
let f = () => 3;
let b = f() + (() => 4)();
let result = o.a() - b;
console.log(b);

function foo(f) {
	return f();
}

foo(() => 3);
'
]

{ #category : #files }
GtDojoImporterExamples >> demo_noModule_js [
	^ 'const http = require("http")
const port = 3000
/* This is a comment 
*/

// This is another comment
const requestHandler = (request, response) => {
  console.log(request.url)
  response.end("Hello Node.js Server!")
}

const server = http.createServer(requestHandler)

server.listen(port, (err) => {
  if (err) {
    return console.log("something bad happened", err)
  }

  console.log(`server is listening on ${port}`)
})'
]

{ #category : #files }
GtDojoImporterExamples >> demo_properties_js [
	^ 'define([''demo/simpleModule''], function(simpleModule) { this.module = simpleModule; this.module.test = () => { return 1 }; this.module.test() })'
]

{ #category : #files }
GtDojoImporterExamples >> demo_simpleModule_js [
	^ 'define([], function() { return {} })'
]

{ #category : #files }
GtDojoImporterExamples >> demo_simplePrereqModule_js [
	^ 'define([''demo/simpleModule''], function(simpleModule) { return simpleModule })'
]

{ #category : #files }
GtDojoImporterExamples >> demo_variables_js [
	^ 'function functionVar(functionParameter) {
		var localVarVariable;
		let localLetVariable = 4;
		const localConstVariable = 3;
		try { 
			localVarVariable = localConstVariable + localLetVariable + functionParameter;
			globalVar = new Array(localVarVariable)
		} catch (catchVariable) { 
			console.log(catchVariable)
		}
		return globalVar}
		
		var anotherFunction = function() { };
		anotherFunction.yetAnotherFunction = () => { return 5 };
		anotherFunction = (each) => { this.property = each }
		localVariable = { objectFunction : function() { return null } }
		
		console.log(functionVar())'
]

{ #category : #'example-tests' }
GtDojoImporterExamples >> dojoClassWithSuperclass [
	<gtExample>
	| importer class |
	importer := self exampleImporter.
	class := importer classNamed: 'demo.dojoClassWithSuperclass'.
	self assert: class superInheritances notEmpty.
	self assert: class anySuperclass == (importer classNamed: 'demo.dojoClassWithoutSuperclass').
	^ class
]

{ #category : #'example-tests' }
GtDojoImporterExamples >> dojoClassWithoutSuperclass [
	<gtExample>
	| importer class |
	importer := self exampleImporter.
	class := importer classNamed: 'demo.dojoClassWithoutSuperclass'.
	self assert: class superInheritances isEmpty.
	^ class
]

{ #category : #'example-tests' }
GtDojoImporterExamples >> dojoNamedClass [
	<gtExample>
	| importer class |
	importer := self exampleImporter.
	class := importer classNamed: 'demo.dojoNamedClass'.
	self assert: class superInheritances notEmpty.
	self assert: class anySuperclass == (importer classNamed: 'demo.dojoClassWithSuperclass').
	^ class
]

{ #category : #samples }
GtDojoImporterExamples >> exampleImporter [
	<gtExample>
	| source |
	source := self exampleProject.
	^ GtDojoImporter new
		rootFolder: source;
		importDirectory: source;
		finishImport
]

{ #category : #samples }
GtDojoImporterExamples >> exampleInvocationScript [
	<gtExample>
	| importer |
	importer := self exampleImporter.
	^ importer scriptNamed: 'demo/invocations.js'
]

{ #category : #samples }
GtDojoImporterExamples >> exampleModel [
	<gtExample>
	^ self exampleImporter model
]

{ #category : #'example-tests' }
GtDojoImporterExamples >> functionNames [
	<gtExample>
	| importer script |
	importer := self exampleImporter.
	script := importer scriptNamed: 'demo/variables.js'.
	script functions detect: [ :each | each name = 'functionVar' ].
	script functions detect: [ :each | each name = 'yetAnotherFunction' ].
	self assert: (script functions select: [ :each | each name = 'anotherFunction' ]) size = 2.
	^ script functions
]

{ #category : #'example-tests' }
GtDojoImporterExamples >> invocations [
	<gtExample>
	| script invocations |
	script := self exampleInvocationScript.
	invocations := script mooseModel allJSInvocations select: [ :each | each sender == script ].
	self assert: invocations size = 5.
	self assert: (invocations anySatisfy: [ :inv | inv candidates anySatisfy: [ :each | each name = 'a' ] ]).
	self assert: (invocations anySatisfy: [ :inv | inv candidates anySatisfy: [ :each | each name = 'f' ] ]).
	self assert: (invocations anySatisfy: [ :inv | inv candidates anySatisfy: [ :each | each name = 'foo' ] ]).
	^ invocations
]

{ #category : #'example-tests' }
GtDojoImporterExamples >> methodNames [
	<gtExample>
	| importer script |
	importer := self exampleImporter.
	script := importer scriptNamed: 'demo/variables.js'.
	script types first methods
		detect: [ :each | each name = 'objectFunction' ].
	^ script types first methods
]

{ #category : #'example-tests' }
GtDojoImporterExamples >> noModuleScript [
	<gtExample>
	| importer script portVariable logProperty |
	importer := self exampleImporter.
	script := importer scriptNamed: 'demo/noModule.js'.
	self assert: script functions size = 2.
	self assert: script localVariables size = 4.
	self assert: (script functions collect: [ :each | each parameters size ]) asSortedCollection asArray = #(1 2).
	portVariable := self variableNamed: 'port' in: script localVariables.
	self assert: (self countOfWriters: portVariable) = 1.
	logProperty := importer propertyNamed: 'log'.
	self assert: (self countOf: (logProperty readAccesses collect: #from) inside: script) = 3.
	^ script
]

{ #category : #files }
GtDojoImporterExamples >> projectFiles [
	^ super projectFiles , 
	{
		{'demo/noModule.js'. self demo_noModule_js}.
		{'demo/simpleModule.js'. self demo_simpleModule_js}.
		{'demo/simplePrereqModule.js'. self demo_simplePrereqModule_js}.
		{'demo/dojoClassWithoutSuperclass.js'. self demo_dojoClassWithoutSuperclass_js}.
		{'demo/dojoClassWithSuperclass.js'. self demo_dojoClassWithSuperclass_js}.
		{'demo/dojoNamedClass.js'. self demo_dojoNamedClass_js}.
		{'demo/properties.js'. self demo_properties_js}.
		{'demo/variables.js'. self demo_variables_js}.
		{'demo/invocations.js'. self demo_invocations_js}
	}
]

{ #category : #'example-tests' }
GtDojoImporterExamples >> properties [
	<gtExample>
	| importer property |
	importer := self exampleImporter.
	property := importer propertyNamed: 'module'.
	self assert: property incomingAccesses size = 3.
	self assert: (self countOfWriters: property) = 1.
	^ property
]

{ #category : #'example-tests' }
GtDojoImporterExamples >> simpleModule [
	<gtExample>
	| importer script |
	importer := self exampleImporter.
	script := importer scriptNamed: 'demo/simpleModule.js'.
	self assert: script functions size = 1.
	^ script
]

{ #category : #'example-tests' }
GtDojoImporterExamples >> simplePrereqModule [
	<gtExample>
	| importer module prereq |
	importer := self exampleImporter.
	module := importer moduleNamed: 'demo/simplePrereqModule'.
	prereq := importer moduleNamed: 'demo/simpleModule'.
	self assert: (module requiredModules includes: prereq).
	self assert: (prereq dependentModules includes: module).
	^ module
]

{ #category : #private }
GtDojoImporterExamples >> variableNamed: aString in: aCollection [
	^ aCollection detect: [ :each | each name = aString ]
]

{ #category : #'example-tests' }
GtDojoImporterExamples >> variables [
	<gtExample>
	| importer script function functionVariable globalVariable functionParameter localVarVariable localLetVariable localConstVariable catchVariable |
	importer := self exampleImporter.
	script := importer scriptNamed: 'demo/variables.js'.
	functionVariable := self variableNamed: 'functionVar' in: script localVariables.
	self assert: (self countOfWriters: functionVariable) = 1.
	self assert: (self countOfReaders: functionVariable) = 1.
	globalVariable := self variableNamed: 'globalVar' in: importer model allGlobalVariables.
	self assert: (self countOfWriters: globalVariable) = 1.
	self assert: (self countOfReaders: globalVariable) = 1.
	function := script functions first.
	functionParameter := function parameters first.
	self assert: (self countOfReaders: functionParameter) = 1.
	localVarVariable := self variableNamed: 'localVarVariable' in: function localVariables.
	self assert: (self countOfWriters: localVarVariable) = 1.
	self assert: (self countOfReaders: localVarVariable) = 1.
	localLetVariable := self variableNamed: 'localLetVariable' in: function localVariables.
	self assert: (self countOfWriters: localLetVariable) = 1.
	self assert: (self countOfReaders: localLetVariable) = 1.
	localConstVariable := self variableNamed: 'localConstVariable' in: function localVariables.
	self assert: (self countOfWriters: localConstVariable) = 1.
	self assert: (self countOfReaders: localConstVariable) = 1.
	catchVariable := self variableNamed: 'catchVariable' in: function localVariables.
	self assert: (self countOfWriters: catchVariable) = 1.
	self assert: (self countOfReaders: catchVariable) = 1.
	^ script
]
