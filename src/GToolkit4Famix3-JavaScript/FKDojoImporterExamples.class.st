Class {
	#name : #FKDojoImporterExamples,
	#superclass : #Object,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #'example-tests' }
FKDojoImporterExamples >> comments [
	<gtExample>
	| importer script |
	importer := self exampleImporter.
	script := importer scriptNamed: 'demo/noModule.js'.
	self assert: script comments size = 2.
	^ script comments
]

{ #category : #private }
FKDojoImporterExamples >> countOf: aCollection inside: aFKJSScript [
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
FKDojoImporterExamples >> countOfReaders: aVariable [
	^ (aVariable incomingAccesses select: #isRead) size
]

{ #category : #private }
FKDojoImporterExamples >> countOfWriters: aVariable [
	^ (aVariable incomingAccesses select: #isWrite) size
]

{ #category : #files }
FKDojoImporterExamples >> demo_dojoClassWithSuperclass_js [
	^ 'define([''dojo/_base/declare'', ''demo/dojoClassWithoutSuperclass''], function(declare, spr) { return declare(spr, { f : function() { return this.attr } })})'
]

{ #category : #files }
FKDojoImporterExamples >> demo_dojoClassWithoutSuperclass_js [
	^ 'define([''dojo/_base/declare''], function(declare) { return declare([], { attr : 1 })})'
]

{ #category : #files }
FKDojoImporterExamples >> demo_dojoNamedClass_js [
	^ 'define([''dojo/_base/declare'', ''demo/dojoClassWithSuperclass''], function(declare, spr) { return declare("demo/dojoNamedClass", [spr], { attr2 : 2 })})'
]

{ #category : #files }
FKDojoImporterExamples >> demo_invocations_js [
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
FKDojoImporterExamples >> demo_noModule_js [
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
FKDojoImporterExamples >> demo_properties_js [
	^ 'define([''demo/simpleModule''], function(simpleModule) { this.module = simpleModule; this.module.test = () => { return 1 }; this.module.test() })'
]

{ #category : #files }
FKDojoImporterExamples >> demo_simpleModule_js [
	^ 'define([], function() { return {} })'
]

{ #category : #files }
FKDojoImporterExamples >> demo_simplePrereqModule_js [
	^ 'define([''demo/simpleModule''], function(simpleModule) { return simpleModule })'
]

{ #category : #files }
FKDojoImporterExamples >> demo_variables_js [
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
FKDojoImporterExamples >> dojoClassWithSuperclass [
	<gtExample>
	| importer class |
	importer := self exampleImporter.
	class := importer dojoClassNamed: 'demo.dojoClassWithSuperclass'.
	self assert: class superInheritances notEmpty.
	self assert: class anySuperclass == (importer dojoClassNamed: 'demo.dojoClassWithoutSuperclass').
	^ class
]

{ #category : #'example-tests' }
FKDojoImporterExamples >> dojoClassWithoutSuperclass [
	<gtExample>
	| importer class |
	importer := self exampleImporter.
	class := importer dojoClassNamed: 'demo.dojoClassWithoutSuperclass'.
	self assert: class superInheritances isEmpty.
	^ class
]

{ #category : #'example-tests' }
FKDojoImporterExamples >> dojoNamedClass [
	<gtExample>
	| importer class |
	importer := self exampleImporter.
	class := importer dojoClassNamed: 'demo.dojoNamedClass'.
	self assert: class superInheritances notEmpty.
	self assert: class anySuperclass == (importer dojoClassNamed: 'demo.dojoClassWithSuperclass').
	^ class
]

{ #category : #samples }
FKDojoImporterExamples >> exampleImporter [
	<gtExample>
	| source |
	source := self exampleProject.
	^ FKDojoImporter new importDirectory: source
]

{ #category : #samples }
FKDojoImporterExamples >> exampleInvocationScript [
	<gtExample>
	| importer |
	importer := self exampleImporter.
	^ importer scriptNamed: 'demo/invocations.js'
]

{ #category : #samples }
FKDojoImporterExamples >> exampleModel [
	<gtExample>
	^ self exampleImporter model
]

{ #category : #samples }
FKDojoImporterExamples >> exampleProject [
	<gtExample>
	| dir |
	dir := FileSystem memory workingDirectory / 'project' / 'src'.
	dir ensureCreateDirectory.
	self projectFiles
		do: [ :each | 
			| filename segments |
			segments := each first asFileReference pathSegments.
			filename := dir.
			1 to: segments size - 1 do: [ :i | filename := filename / (segments at: i) ].
			filename ensureCreateDirectory.
			filename := filename / segments last.
			filename writeStreamDo: [ :stream | stream nextPutAll: each last ] ].
	^ dir
]

{ #category : #'example-tests' }
FKDojoImporterExamples >> functionNames [
	<gtExample>
	| importer script |
	importer := self exampleImporter.
	script := importer scriptNamed: 'demo/variables.js'.
	script functions detect: [ :each | each name = 'functionVar' ].
	script functions detect: [ :each | each name = 'objectFunction' ].
	script functions detect: [ :each | each name = 'yetAnotherFunction' ].
	self assert: (script functions select: [ :each | each name = 'anotherFunction' ]) size = 2.
	^ script functions
]

{ #category : #'example-tests' }
FKDojoImporterExamples >> invocations [
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
FKDojoImporterExamples >> noModuleScript [
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
FKDojoImporterExamples >> projectFiles [
	^ {
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
FKDojoImporterExamples >> properties [
	<gtExample>
	| importer property |
	importer := self exampleImporter.
	property := importer propertyNamed: 'module'.
	self assert: property incomingAccesses size = 3.
	self assert: (self countOfWriters: property) = 1.
	^ property
]

{ #category : #'example-tests' }
FKDojoImporterExamples >> simpleModule [
	<gtExample>
	| importer script |
	importer := self exampleImporter.
	script := importer scriptNamed: 'demo/simpleModule.js'.
	self assert: script functions size = 1.
	^ script
]

{ #category : #'example-tests' }
FKDojoImporterExamples >> simplePrereqModule [
	<gtExample>
	| importer module prereq |
	importer := self exampleImporter.
	module := importer dojoModuleNamed: 'demo/simplePrereqModule'.
	prereq := importer dojoModuleNamed: 'demo/simpleModule'.
	self assert: (module requiredModules includes: prereq).
	self assert: (prereq dependentModules includes: module).
	^ module
]

{ #category : #private }
FKDojoImporterExamples >> variableNamed: aString in: aCollection [
	^ aCollection detect: [ :each | each name = aString ]
]

{ #category : #'example-tests' }
FKDojoImporterExamples >> variables [
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
