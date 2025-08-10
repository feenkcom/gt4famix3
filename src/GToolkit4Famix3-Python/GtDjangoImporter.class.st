Class {
	#name : #GtDjangoImporter,
	#superclass : #GtPythonImporter,
	#instVars : [
		'urlPatterns'
	],
	#category : #'GToolkit4Famix3-Python'
}

{ #category : #'llm-generated' }
GtDjangoImporter >> djCallArgumentsTextFor: aCallNode [
	(aCallNode respondsTo: #arguments) ifFalse: [ ^ #() ].
	^ aCallNode arguments collect: [ :arg | (self djNodeText: arg) ifNotNil: [ :t | t trimmed ] ifNil: [ '' ] ]
]

{ #category : #'llm-generated' }
GtDjangoImporter >> djCalleeLastNameOf: aCallNode [
	| callee calleeText |
	(aCallNode isNil) ifTrue: [ ^ nil ].
	callee := (self respondsTo: #pythonCalleeOf:) ifTrue: [ self pythonCalleeOf: aCallNode ] ifFalse: [ nil ].
	callee ifNil: [ ^ nil ].
	calleeText := self djNodeText: callee.
	^ self djLastIdentifierIn: calleeText
]

{ #category : #'as yet unclassified' }
GtDjangoImporter >> djEnsureAttributeNamed: aName inClass: clazz [
	| attr |
	attr := (clazz respondsTo: #attributes)
		ifTrue: [ clazz attributes
				detect: [ :ea | ea name = aName ]
				ifNone: [ nil ] ]
		ifFalse: [ nil ].
	attr ifNotNil: [ ^ attr ].
	attr := FAMIXAttribute new name: aName.
	(model notNil) ifTrue: [ model add: attr ].
	(currentFile notNil) ifTrue: [ currentFile addEntity: attr ].
	(attr respondsTo: #parentType:) ifTrue: [ attr parentType: clazz ].
	(clazz respondsTo: #addAttribute:) ifTrue: [ clazz addAttribute: attr ].
	^ attr
]

{ #category : #'llm-generated' }
GtDjangoImporter >> djExtractLHSNameFromAssignment: anAssignmentStatement [
	| target text idx lhs |
	(anAssignmentStatement respondsTo: #targets) ifTrue: [
		(anAssignmentStatement targets respondsTo: #isEmpty) ifTrue: [ anAssignmentStatement targets isEmpty ifTrue: [ ^ nil ] ].
		target := anAssignmentStatement targets first.
		^ (target respondsTo: #name)
			ifTrue: [ target name source ]
			ifFalse: [ (target respondsTo: #source) ifTrue: [ target source ] ifFalse: [ self djNodeText: target ] ] ].
	text := self djNodeText: anAssignmentStatement.
	text ifNil: [ ^ nil ].
	idx := text indexOf: $= ifAbsent: [ ^ nil ].
	lhs := (text copyFrom: 1 to: idx - 1) trimmed.
	((lhs includes: $. ) or: [ lhs includes: Character space ])
		ifTrue: [ ^ (lhs findTokens: ' .	') ifEmpty: [ nil ] ifNotEmpty: [ :t | t last ] ]
		ifFalse: [ ^ lhs ]
]

{ #category : #'as yet unclassified' }
GtDjangoImporter >> djExtractModelNameFromArgumentText: argText [
	| s parts |
	s := self djTrimQuotes: argText.
	s isEmpty ifTrue: [ ^ nil ].
	"Handle 'app.Model' or 'Model' or 'app.Model'"
	parts := s findTokens: '.'.
	^ parts ifEmpty: [ nil ] ifNotEmpty: [ parts last ]
]

{ #category : #'llm-generated' }
GtDjangoImporter >> djLastIdentifierIn: aString [
	| s tokens |
	aString ifNil: [ ^ nil ].
	s := aString asString.
	tokens := s findTokens: ' .()	
'.
	^ tokens ifEmpty: [ nil ] ifNotEmpty: [ tokens last ]
]

{ #category : #'as yet unclassified' }
GtDjangoImporter >> djMapFieldTypeToFamixType: fieldTypeName [
	| name |
	name := fieldTypeName asString.
	(name endsWith: 'CharField') ifTrue: [ ^ stringType ].
	(name endsWith: 'TextField') ifTrue: [ ^ stringType ].
	(name endsWith: 'SlugField') ifTrue: [ ^ stringType ].
	(name endsWith: 'EmailField') ifTrue: [ ^ stringType ].
	(name endsWith: 'URLField') ifTrue: [ ^ stringType ].
	(name endsWith: 'UUIDField') ifTrue: [ ^ stringType ].
	(name endsWith: 'IPAddressField') ifTrue: [ ^ stringType ].
	(name endsWith: 'IntegerField') ifTrue: [ ^ numberType ].
	(name endsWith: 'AutoField') ifTrue: [ ^ numberType ].
	(name endsWith: 'BigIntegerField') ifTrue: [ ^ numberType ].
	(name endsWith: 'SmallIntegerField') ifTrue: [ ^ numberType ].
	(name endsWith: 'PositiveIntegerField') ifTrue: [ ^ numberType ].
	(name endsWith: 'DecimalField') ifTrue: [ ^ numberType ].
	(name endsWith: 'FloatField') ifTrue: [ ^ numberType ].
	(name endsWith: 'BooleanField') ifTrue: [ ^ booleanType ].
	"Dates: keep as string by default"
	(name endsWith: 'DateField') ifTrue: [ ^ stringType ].
	(name endsWith: 'DateTimeField') ifTrue: [ ^ stringType ].
	(name endsWith: 'TimeField') ifTrue: [ ^ stringType ].
	^ nil
]

{ #category : #'as yet unclassified' }
GtDjangoImporter >> djMarkClassAsDjangoModel: clazz [
	clazz propertyNamed: #djangoModel put: true.
	^ clazz
]

{ #category : #'llm-generated' }
GtDjangoImporter >> djMaybeProcessModelFieldAssignment: anAssignmentStatement in: aScope [
	| clazz lhsName rhsNode rhsText fieldTypeName attr relationTargetName targetClass famixType |
	(aScope isKindOf: FAMIXClass) ifFalse: [ ^ self ].
	clazz := aScope.
	
	"Extract LHS field name"
	lhsName := self djExtractLHSNameFromAssignment: anAssignmentStatement.
	lhsName ifNil: [ ^ self ].
	
	"Extract RHS call/type"
	rhsNode := (anAssignmentStatement respondsTo: #value)
		ifTrue: [ anAssignmentStatement value ]
		ifFalse: [ nil ].
	rhsText := self djNodeText: (rhsNode ifNil: [ anAssignmentStatement ]).
	fieldTypeName := rhsNode
		ifNotNil: [ self djCalleeLastNameOf: rhsNode ]
		ifNil: [ self djLastIdentifierIn: rhsText ].
	fieldTypeName ifNil: [ ^ self ].
	
	"Heuristic: consider only Django Field constructors (CharField, IntegerField, ...),
	and relation fields (ForeignKey, OneToOneField, ManyToManyField)."
	((fieldTypeName endsWith: 'Field')
		or: [ #( 'ForeignKey' 'OneToOneField' 'ManyToManyField' ) includes: fieldTypeName ]) ifFalse: [ ^ self ].
	
	"Ensure attribute on the class and annotate"
	attr := self djEnsureAttributeNamed: lhsName inClass: clazz.
	self storeAST: anAssignmentStatement into: attr.
	attr sourceAnchor: (self sourceAnchorFor: anAssignmentStatement).
	attr propertyNamed: #djangoFieldType put: fieldTypeName.
	attr propertyNamed: #djangoRaw put: rhsText.
	
	self djMarkClassAsDjangoModel: clazz.
	
	"Set declared type for primitive fields"
	famixType := self djMapFieldTypeToFamixType: fieldTypeName.
	(famixType notNil and: [ attr respondsTo: #declaredType: ]) ifTrue: [ attr declaredType: famixType ].
	
	"Handle relations: take first argument as target model name (string or bare class)."
	(#( 'ForeignKey' 'OneToOneField' 'ManyToManyField' ) includes: fieldTypeName) ifTrue: [
		| argsTexts |
		attr propertyNamed: #djangoRelationKind put: fieldTypeName.
		argsTexts := rhsNode ifNotNil: [ self djCallArgumentsTextFor: rhsNode ] ifNil: [ #() ].
		argsTexts ifNotEmpty: [
			relationTargetName := self djExtractModelNameFromArgumentText: argsTexts first.
			relationTargetName ifNotNil: [
				targetClass := classes at: relationTargetName ifAbsent: [ nil ].
				(targetClass notNil and: [ attr respondsTo: #declaredType: ]) ifTrue: [ attr declaredType: targetClass ].
				attr propertyNamed: #djangoRelationTarget put: relationTargetName ] ] ].
	^ self
]

{ #category : #'llm-generated' }
GtDjangoImporter >> djNameForCall: aCall [
	| name |
	name := self pythonFirstNameChildSourceOf: aCall.
	^ name ifNotNil: [ name asString ]
]

{ #category : #'llm-generated' }
GtDjangoImporter >> djNodeText: aNode [
	| src start stop |
	(aNode isNil) ifTrue: [ ^ nil ].
	src := (aNode respondsTo: #completeSource)
		ifTrue: [ aNode completeSource ]
		ifFalse: [ nil ].
	(src notNil and: [ aNode respondsTo: #startPosition ]) ifTrue: [
		start := aNode startPosition.
		stop := (aNode respondsTo: #stopPosition) ifTrue: [ aNode stopPosition ] ifFalse: [ start ].
		^ (src copyFrom: start to: stop) asString ].
	^ (aNode respondsTo: #source) ifTrue: [ aNode source ] ifFalse: [ nil ]
]

{ #category : #'llm-generated' }
GtDjangoImporter >> djTrimQuotes: aString [
	| s |
	s := aString asString trimmed.
	(s size >= 2 and: [ (#( $' $" ) includes: (s first)) and: [ s last = s first ] ])
		ifTrue: [ ^ s copyFrom: 2 to: s size - 1 ]
		ifFalse: [ ^ s ]
]

{ #category : #'llm-generated' }
GtDjangoImporter >> finishImport [
	"Hook for Django-specific post-processing.
	Currently, we only rely on the annotations produced in processCallExpressions.
	You could, for example, link URL patterns to view functions/classes more explicitly here.
	"
	super finishImport.
	^ self
]

{ #category : #'as yet unclassified' }
GtDjangoImporter >> gtDjangoModelsViewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Django models';
		priority: 5;
		items: [ classes values select: [ :c | (c propertyNamed: #djangoModel ifAbsent: [ false ]) = true ] ];
		column: 'Model' text: #name;
		column: '#fields' text: [ :c | (c respondsTo: #attributes) ifTrue: [ c attributes size asString ] ifFalse: [ '-' ] ]
]

{ #category : #'llm-generated' }
GtDjangoImporter >> initialize [
	super initialize.
	urlPatterns := OrderedCollection new
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
		name := self djNameForCall: call.
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
GtDjangoImporter >> visitAssignmentStatement: anAssignmentStatement [
	"Record the assignment, then try to detect Django ORM model fields.
	We keep the superclass behavior.
	"
	assignmentExpressions add: anAssignmentStatement -> self currentScope.
	self djMaybeProcessModelFieldAssignment: anAssignmentStatement in: self currentScope.
	^ super visitAssignmentStatement: anAssignmentStatement
]
