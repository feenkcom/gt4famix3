"
importer := FKAngularImporter new.
root := '/Users/girba/Work/feenk/Jonas-JS/src' asFileReference.
importer importFiles: ((root) allFiles select: [ :each | each extension = 'js' ]).
modules := importer modules values asMooseGroup .
view := RTMondrian new.
(modules reject: #isStub) asMooseGroup viewDependenciesOn: view.
view

"
Class {
	#name : #GtAngularImporter,
	#superclass : #GtJSImporter,
	#instVars : [
		'components',
		'injectables'
	],
	#category : #'GToolkit4Famix3-JavaScript-Importer'
}

{ #category : #'as yet unclassified' }
GtAngularImporter class >> annotation [
	<MSEClass: #Type super: #FAMIXNamedEntity>
	
]

{ #category : #importing }
GtAngularImporter >> createSourceAnchorFor: anEntity fileName: aString start: startPosition end: stopPosition [
	| sourceAnchor |
	sourceAnchor := FAMIXIndexedFileAnchor new 
		startPos: startPosition; 
		endPos: stopPosition; 
		fileName: aString.
	model add: sourceAnchor.
	anEntity sourceAnchor: sourceAnchor.
]

{ #category : #importing }
GtAngularImporter >> createTemplateFromEmbeddedAssignment: anAssignmentValue fromComponent: aFamixComponent [
	| template |
	template := (GtAngularTemplate new)
		name: aFamixComponent mooseName , '-template';
		isEmbedded: true;
		sourceAnchor: (self sourceAnchorFor: anAssignmentValue value).
	aFamixComponent template: template.
	template component: aFamixComponent.
	model add: template.
	^ template
]

{ #category : #importing }
GtAngularImporter >> ensureComponentNamed: aString inModule: aModule [
	^ components 
		at: aModule mooseName, '-', aString
		ifAbsentPut: [
			GtAngularEmbeddableComponent new 
					name: aString;
					parentModule: aModule;
					isStub: true ]
]

{ #category : #importing }
GtAngularImporter >> ensureInjectableNamed: aString [
	^ self injectables 
		at: aString
		ifAbsentPut: [ GtAngularInjectable new name: aString ]
]

{ #category : #importing }
GtAngularImporter >> ensureModuleNamed: aName [
	^ modules 
		at: aName 
		ifAbsentPut: [ 
			(GtAngularModule new name: aName) isStub: true ] 
]

{ #category : #importing }
GtAngularImporter >> ensureRouteProviderNamed: aString inModule: aModule [
	^ components 
		at: aModule mooseName, '-', aString
		ifAbsentPut: [
			GtAngularRouteProvider new 
					name: aString;
					parentModule: aModule;
					isStub: true ]
]

{ #category : #importing }
GtAngularImporter >> ensureTemplateForUrl: aString [
	| pieces |
	pieces := aString piecesCutWhere: [ :a :b | a = $/ ].
	^ model allAngularTemplates
		detect: [ :each | (each name endsWith: pieces last) and: [ each name includesSubstring: pieces first ] ]
		ifNone:
			[ | template |
			template := (GtAngularTemplate new)
				name: aString;
				isStub: true.
			model add: template.
			template ]
]

{ #category : #importing }
GtAngularImporter >> importComponentFromNode: aNode withMapping: mapping inFile: aFileReference inModule: module [
	| component |
	component := (self ensureComponentNamed: (mapping at: 'arg1') source pharoFromJSString inModule: module)
		isStub: false;
		sourceAnchor: (self sourceAnchorFor: aNode).
	self storeAST: aNode into: component.
	(mapping at: 'arg2')
		allNodesDo:
			[ :node | 
			(node class = JSPropertyAssignmentNode
				and: [ node name name value = 'templateUrl' and: [ node value isKindOf: JSLiteralNode ] ])
				ifTrue: [ component templateUrl: node value asPharoString ].
			(node class = JSPropertyAssignmentNode and: [ node name name value = 'template' ])
				ifTrue: [ self createTemplateFromEmbeddedAssignment: node value fromComponent: component ] ].
	^ component
]

{ #category : #importing }
GtAngularImporter >> importComponentsInModule: module inFile: file [
	(module propertyNamed: #ast)
		expressionsMatching: '``?something`.component(``?arg1`, ``?arg2`)'
		do:
			[ :each :mapping | 
			self
				importComponentFromNode: each
				withMapping: mapping
				inFile: file
				inModule: module ].
	(module propertyNamed: #ast)
		expressionsMatching: '``?something`.directive(``?arg1`, ``?arg2`)'
		do:
			[ :each :mapping | 
			self
				importComponentFromNode: each
				withMapping: mapping
				inFile: file
				inModule: module ]
]

{ #category : #importing }
GtAngularImporter >> importConfigurationsOfModule: module inFile: aFileReference [
	(module propertyNamed: #ast)
		expressionsMatching: '``?something`.config(``?arg`)'
		do:
			[ :config :m | 
			config
				expressionsMatching: '$routeProvider.when(``?arg1`, ``?arg2`)'
				do:
					[ :each :mapping | 
					self
						importRouteProviderFromNode: each
						withMapping: mapping
						inFile: aFileReference
						inModule: module ].
			config arguments last class = JSFunctionNode
				ifTrue:
					[ config arguments last statements
						do:
							[ :each | 
							each class = JSVariableStatementNode
								ifTrue:
									[ self
										importRouteProviderFromVariableDefinitionNode: config
										withStatements: each
										inFile: aFileReference
										inModule: module ] ] ] ]
]

{ #category : #importing }
GtAngularImporter >> importDirectory: aDirectory excluding: patternCollection [
	super importDirectory: aDirectory excluding: patternCollection.
	(aDirectory allFiles select: [ :each | each extension = 'html' ])	
		do: [ :file | self importHtmlFile: file ]
		displayingProgress: 'Html Files'.
	self populateModel.
	self resolveTemplateAndComponentsInclusion.
	self resolveInjectables
]

{ #category : #importing }
GtAngularImporter >> importHtmlFile: aFileReference [
	| template relativeFileName |
	relativeFileName := String
		streamContents: [ :s | (aFileReference relativeTo: model rootFolder asFileReference) printOn: s delimiter: $/ ].
	template := GtAngularTemplate new name: relativeFileName.
	self
		createSourceAnchorFor: template
		fileName: relativeFileName
		start: 1
		end: (self contentsOfFile: aFileReference) size.
	model add: template
]

{ #category : #importing }
GtAngularImporter >> importInjectableWithOneArgFromNode: rootNode in: module definedInNode: moduleNode [
	self importInjectionDefinitionFor: 'run' fromRootNode: rootNode in: module defininedInNode: moduleNode.
	self importInjectionDefinitionFor: 'config' fromRootNode: rootNode in: module defininedInNode: moduleNode.

]

{ #category : #importing }
GtAngularImporter >> importInjectableWithTwoArgsFor: anAngularInjectionFunctionName fromNode: rootNode in: module definedInNode: moduleNode [
	| factoryPattern mappings injectionVariable injectable |
	factoryPattern := JSParser
		parse: '``?something`.' , anAngularInjectionFunctionName , '(``?arg1`, ``?arg2`)'
		startingAt: JSParser startingStateForExpression.
	rootNode
		allNodesDo:
			[ :node | 
			mappings := Dictionary new.
			factoryPattern match: node inContext: mappings.
			mappings notEmpty
				ifTrue:
					[ mappings associations
						do:
							[ :each | 
							each key name = 'arg1'
								ifTrue:
									[ each value class = JSStringLiteralNode
										ifTrue:
											[ injectionVariable := each value value value pharoFromJSString.
											injectable := self ensureInjectableNamed: injectionVariable.
											injectable
												parentModule: module;
												kind: anAngularInjectionFunctionName.
											self storeAST: node into: injectable ] ] ] ] ]
]

{ #category : #importing }
GtAngularImporter >> importInjectableWithTwoArgsFromNode: rootNode in: module definedInNode: moduleNode [
	self importInjectableWithTwoArgsFor: 'factory' fromNode: rootNode in: module definedInNode: moduleNode.
	self importInjectableWithTwoArgsFor: 'constant' fromNode: rootNode in: module definedInNode: moduleNode.
	self importInjectableWithTwoArgsFor: 'provider' fromNode: rootNode in: module definedInNode: moduleNode.
	self importInjectableWithTwoArgsFor: 'service' fromNode: rootNode in: module definedInNode: moduleNode.
	self importInjectableWithTwoArgsFor: 'value' fromNode: rootNode in: module definedInNode: moduleNode.
	self importInjectableWithTwoArgsFor: 'filter' fromNode: rootNode in: module definedInNode: moduleNode
]

{ #category : #importing }
GtAngularImporter >> importRouteProviderFromNode: aNode withMapping: mapping inFile: aFileReference inModule: module [
	| component |
	component := (self ensureRouteProviderNamed: '$routeProvider' , (module routeProviders size + 1) asString inModule: module)
		isStub: false;
		sourceAnchor: (self sourceAnchorFor: aNode).
	self storeAST: aNode into: component.
	(mapping at: 'arg2')
		withAllNodesDo:
			[ :node | 
			(node class = JSPropertyAssignmentNode and: [ node key name value = 'templateUrl' ])
				ifTrue: [ component templateUrl: node value asPharoString ].
			(node class = JSPropertyAssignmentNode and: [ node key name value = 'template' ])
				ifTrue: [ self createTemplateFromEmbeddedAssignment: node value fromComponent: component ] ].
	^ component
]

{ #category : #importing }
GtAngularImporter >> importRouteProviderFromVariableDefinitionNode: aNode withStatements: statements inFile: aFileReference inModule: module [
	| component |
	component := (self ensureRouteProviderNamed: '$routeProvider' , (module routeProviders size + 1) asString inModule: module)
		isStub: false.
	self storeAST: aNode into: component.
	component sourceAnchor: (self sourceAnchorFor: aNode).
	statements
		withAllNodesDo:
			[ :node | 
			(node class = JSPropertyAssignmentNode
				and: [ node name name value = 'templateUrl' and: [ node value class = JSStringLiteralNode ] ])
				ifTrue: [ component templateUrl: node value asPharoString ].
			(node class = JSPropertyAssignmentNode and: [ node name name value = 'template' ])
				ifTrue: [ self createTemplateFromEmbeddedAssignment: node value fromComponent: component ] ].
	^ component
]

{ #category : #initialize }
GtAngularImporter >> initialize [
	super initialize.
	modules := Dictionary new.
	components := Dictionary new.
	injectables := Dictionary new
]

{ #category : #accessing }
GtAngularImporter >> injectables [
	^ injectables
]

{ #category : #accessing }
GtAngularImporter >> modules [
	^ modules
]

{ #category : #accessing }
GtAngularImporter >> modules: anObject [
	modules := anObject
]

{ #category : #importing }
GtAngularImporter >> populateModel [
	modules do: [ :each | model add: each ].
	components do: [ :each | model add: each ].
	injectables do: [ :each | model add: each ]
]

{ #category : #importing }
GtAngularImporter >> processJSAst: rootNode [
	super processJSAst: rootNode.
	^ rootNode
		expressionsMatching: 'angular.module(``?arg1`, ``?arg2`)'
		do:
			[ :node :mapping | 
			| module submodules parentModule moduleNode |
			parentModule := (mapping at: 'arg1') value value value pharoFromJSString.
			submodules := (mapping at: 'arg2') value expressions collect: [ :expr | expr value value pharoFromJSString ].
			moduleNode := (node parentOfType: JSExpressionStatementNode) ifNil: [ node ].
			module := (self ensureModuleNamed: parentModule)
				addDependencies: (submodules collect: [ :sub | self ensureModuleNamed: sub ]);
				addDefiningFile: rootNode filename;
				sourceAnchor: (self sourceAnchorFor: moduleNode);
				isStub: false.
			self storeAST: moduleNode into: module.
			self importComponentsInModule: module inFile: rootNode filename.
			self importConfigurationsOfModule: module inFile: rootNode filename.
			self
				importInjectableWithTwoArgsFromNode: rootNode
				in: module
				definedInNode: node ]
]

{ #category : #importing }
GtAngularImporter >> resolveInjectables [
	| possibleFunction |
	self injectables values
		do:
			[ :injectable | 
			(injectable propertyNamed: #ast) arguments size = 2
				ifTrue:
					[ possibleFunction := (injectable propertyNamed: #ast) arguments second.
					(possibleFunction isKindOf: JSFunctionNode)
						ifTrue:
							[ possibleFunction parameters
								do:
									[ :possiblyInjectedArgument | 
									self injectables
										at: possiblyInjectedArgument value
										ifPresent: [ :usedInjectable | injectable addUsedInjectable: usedInjectable ] ] ] ] ]
]

{ #category : #importing }
GtAngularImporter >> resolveTemplateAndComponentsInclusion [
	"| htmlComponents templatesByShortName |
	components values do: [ :component |
		component templateUrl notNil ifTrue: [
			| template | 
			template := (self ensureTemplateForUrl: component templateUrl).
			component template: template.
			template component: component ] ].
	htmlComponents := components values groupedBy: [ :each | each htmlName ].
	templatesByShortName := (targetModel allAngularTemplates select: [ :each | each name endsWith: 'html' ] thenCollect: [:each | each mobiShortName -> each ]) asDictionary.
	targetModel allAngularTemplates do: [ :template |
		| html |
		html := Soup fromString: template sourceText.
		((html // 'ng-include') collect: [:each | (each attributeAt: 'src') pharoFromJSString ])
			do: [ :url | 
				| includedTemplate |
				includedTemplate := (self ensureTemplateForUrl: url).
				template includedTemplates add: includedTemplate ].
		html withDeep: [:each | each children] do: [ :each | 
			each hasAttributes ifTrue: [
				each attributes associations do: [ :attr | 
					templatesByShortName 
						at: attr value
						ifPresent: [ :includedTemplate | template includedTemplates add: includedTemplate ] ] ] ].
		htmlComponents keys do: [ :htmlComponent | 
			(html // htmlComponent) notEmpty ifTrue: [ 
				template includedComponents addAll: (htmlComponents at: htmlComponent) ] ].
		template  ]"
]

{ #category : #accessing }
GtAngularImporter >> targetModel [
	^ model
]
