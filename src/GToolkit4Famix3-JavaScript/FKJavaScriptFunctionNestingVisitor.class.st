Class {
	#name : #FKJavaScriptFunctionNestingVisitor,
	#superclass : #JSProgramNodeVisitor,
	#instVars : [
		'importer',
		'stack'
	],
	#category : #'GToolkit4Famix3-JavaScript-Importer'
}

{ #category : #accessing }
FKJavaScriptFunctionNestingVisitor >> importer [
	^ importer
]

{ #category : #accessing }
FKJavaScriptFunctionNestingVisitor >> importer: anObject [
	importer := anObject
]

{ #category : #initialize }
FKJavaScriptFunctionNestingVisitor >> initialize [
	stack := Stack new
]

{ #category : #visiting }
FKJavaScriptFunctionNestingVisitor >> visitFunction: aFunction [
	| famixFunction |
	famixFunction := self importer ensureFunctionNamed: aFunction name value.
	stack notEmpty ifTrue: [ famixFunction container: stack top ].
	stack push: famixFunction.
	super visitFunction: aFunction.
	stack pop
]
