Class {
	#name : #GtJavaScriptFunctionNestingVisitor,
	#superclass : #JSProgramNodeVisitor,
	#instVars : [
		'importer',
		'stack'
	],
	#category : #'GToolkit4Famix3-JavaScript-Importer'
}

{ #category : #accessing }
GtJavaScriptFunctionNestingVisitor >> importer [
	^ importer
]

{ #category : #accessing }
GtJavaScriptFunctionNestingVisitor >> importer: anObject [
	importer := anObject
]

{ #category : #initialize }
GtJavaScriptFunctionNestingVisitor >> initialize [
	stack := Stack new
]

{ #category : #visiting }
GtJavaScriptFunctionNestingVisitor >> visitFunction: aFunction [
	| famixFunction |
	famixFunction := self importer ensureFunctionNamed: aFunction name value.
	stack notEmpty ifTrue: [ famixFunction container: stack top ].
	stack push: famixFunction.
	super visitFunction: aFunction.
	stack pop
]
