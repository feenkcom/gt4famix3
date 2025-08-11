Class {
	#name : #GtDjangoImporter,
	#superclass : #GtPythonImporter,
	#instVars : [
		'urlPatterns'
	],
	#category : #'GToolkit4Famix3-Python'
}

{ #category : #'llm-generated' }
GtDjangoImporter >> gtSummaryViewFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Summary';
		priority: 1;
		text: [ String streamContents: [ :s |
			s nextPutAll: 'Files: '; nextPutAll: self files size asString; cr.
			s nextPutAll: 'URL patterns: '; nextPutAll: self urlPatterns size asString ] ]
]

{ #category : #'llm-generated' }
GtDjangoImporter >> gtUrlPatternsViewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'URL Patterns';
		priority: 20;
		items: [ self urlPatterns asOrderedCollection ];
		column: 'Pattern' text: [ :each |
			(each respondsTo: #pattern)
				ifTrue: [ each pattern asString ]
				ifFalse: [ each asString ] ];
		column: 'Name' text: [ :each |
			(each respondsTo: #name)
				ifTrue: [ each name asString ]
				ifFalse: [ '' ] ];
		column: 'View' text: [ :each |
			(each respondsTo: #view)
				ifTrue: [ each view asString ]
				ifFalse: [ '' ] ]
]

{ #category : #'llm-generated' }
GtDjangoImporter >> initialize [
	super initialize.
	urlPatterns := OrderedCollection new
]

{ #category : #'llm-generated' }
GtDjangoImporter >> nameForCall: aCall [
	| name |
	name := self pythonFirstNameChildSourceOf: aCall.
	^ name ifNotNil: [ name asString ]
]

{ #category : #'llm-generated' }
GtDjangoImporter >> processCallExpressions [
	"Extend the base behavior to annotate Django-specific calls like
	 - django.urls.path / re_path (URL patterns)
	 - django.shortcuts.render (template rendering)
	The method largely mirrors the superclass implementation and adds annotations.
	"
	callExpressions do: [ :each |
		| call scope invocation callee args name |
		call := each key.
		scope := each value.
		invocation := FAMIXInvocation new
			sender: scope;
			sourceAnchor: (self sourceAnchorFor: call).
		args := (call respondsTo: #arguments)
			ifTrue: [ call arguments collect: [ :arg | self modelObjectFrom: arg in: scope ] ]
			ifFalse: [ #() ].
		invocation propertyNamed: #arguments put: args.
		callee := self pythonCalleeOf: call.
		callee ifNotNil: [
			(callee attributeNamed: #modelObject ifAbsent: [ nil ])
				ifNotNil: [ :func | invocation addCandidate: func ]
				ifNil: [ invocation receiver: (self modelObjectFrom: callee in: scope) ] ].

		"Django-specific annotations"
		name := self nameForCall: call.
		((name = 'path') or: [ name = 're_path' ]) ifTrue: [
			invocation propertyNamed: #djangoUrl put: true.
			args size >= 1 ifTrue: [ invocation propertyNamed: #djangoRoute put: (args first) ].
			args size >= 2 ifTrue: [ invocation propertyNamed: #djangoView put: (args second) ].
			urlPatterns add: invocation ].
		(name = 'render') ifTrue: [
			invocation propertyNamed: #djangoRender put: true.
			args size >= 2 ifTrue: [ invocation propertyNamed: #djangoTemplate put: (args second) ] ].

		model add: invocation.
		self storeAST: call into: invocation.
		(self fileFor: scope) ifNotNil: [ :file | file addEntity: invocation ] ]
]

{ #category : #'llm-generated' }
GtDjangoImporter >> urlPatterns [
	^ urlPatterns ifNil: [ #() ]
]
