"
This visitor reifies the structure that it traverses without reifying relations. This happens at a later stage in the importer. The visitor places the AST in the model entities to allow the later stage to retrieve the relation information.
"
Class {
	#name : #FKDelphiPasStructureVisitor,
	#superclass : #DelphiProgramNodeVisitor,
	#instVars : [
		'importer',
		'stack',
		'fileName',
		'isInterfaceSection',
		'currentBehavior'
	],
	#category : #'GToolkit4Famix3-Delphi-Importer'
}

{ #category : #private }
FKDelphiPasStructureVisitor >> currentBehavior [
	[ stack top isKindOf: FAMIXBehaviouralEntity ] assert.
	^ stack top
]

{ #category : #accessing }
FKDelphiPasStructureVisitor >> fileName: aString [ 
	fileName := aString
]

{ #category : #accessing }
FKDelphiPasStructureVisitor >> importer [
	^ importer
]

{ #category : #accessing }
FKDelphiPasStructureVisitor >> importer: anObject [
	importer := anObject
]

{ #category : #initialize }
FKDelphiPasStructureVisitor >> initialize [
	stack := Stack new.
	isInterfaceSection := false.
]

{ #category : #private }
FKDelphiPasStructureVisitor >> localTypeNamed: aString [
	^ stack first types detect: [ :each | each name asLowercase = aString asLowercase]
]

{ #category : #private }
FKDelphiPasStructureVisitor >> push: anEntity andDo: aBlock [
	stack push: anEntity.
	aBlock value.
	stack pop
]

{ #category : #accessing }
FKDelphiPasStructureVisitor >> unit [
	^ stack last
]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitAnonymousMethodType: aNode [
	self flag: 'we ignore it for now'.
	
]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitArgument: aNode [
	aNode names do: [ :each | 
		| variable |
		variable := importer ensureParameterNamed: each value inBehavior: self currentBehavior.
		variable isStub: false.
		variable fkDelphiAST: aNode ].
	super visitArgument: aNode
]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitAssignmentExpression: aNode [
	| access |
	access := importer createBasicAccessFromBehavior: stack top.
	access isWrite: true.
	access fkDelphiAST: aNode lhs.
	super visitAssignmentExpression: aNode
]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitConstantDefinition: aNode [
	| variable |
	variable := (stack top isClass) 
		ifFalse: [ importer ensureConstant: aNode name value inUnit: self unit ]
		ifTrue: [ importer ensureConstant: aNode name value inType: stack top ].
	variable isStub: false.
	variable fkDelphiAST: aNode
]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitFinalizationSection: aNode [
	| famixBehavior |
	famixBehavior := importer ensureFunctionNamed: '__FINALIZATION__' inUnit: stack first.
	importer 
		createSourceAnchorFor: famixBehavior 
		fileName: fileName 
		start: aNode startPosition 
		end: aNode stopPosition.
	self
		push: famixBehavior
		andDo: [ super visitFinalizationSection: aNode ].

]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitInitializationSection: aNode [
	| famixBehavior |
	famixBehavior := importer ensureFunctionNamed: '__INITIALIZATION__' inUnit: stack first.
	importer 
		createSourceAnchorFor: famixBehavior 
		fileName: fileName 
		start: aNode startPosition 
		end: aNode stopPosition.
	self
		push: famixBehavior
		andDo: [ super visitInitializationSection: aNode ].

]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitInterfaceSection: aNode [

	isInterfaceSection := true.
	super visitInterfaceSection: aNode.
	isInterfaceSection := false.
]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitMainMethodDefinition: aNode [
	| famixBehavior |
	famixBehavior := importer ensureFunctionNamed: '__MAIN__' inUnit: stack first.
	famixBehavior fkDelphiAST: aNode.
	famixBehavior isStub: false.
	importer 
		createSourceAnchorFor: famixBehavior 
		fileName: fileName 
		start: aNode startPosition 
		end: aNode stopPosition.
	self
		push: famixBehavior
		andDo: [ super visitMainMethodDefinition: aNode ].

]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitMethodCallExpression: aMethodCallExpression [
	| invocation |
	invocation := importer 
		createBasicInvocationsFromBehavior: stack top
		toFunctionNamed: aMethodCallExpression receiver name value.
	invocation fkDelphiAST: aMethodCallExpression. 
	super visitMethodCallExpression: aMethodCallExpression
]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitMethodDefinition: aNode [
	| famixBehavior qualifiedNameNode |
	qualifiedNameNode := aNode header qualifiedName.
	famixBehavior := qualifiedNameNode namespace 
		ifNil: [ 
			"it means we have a simple function"
			importer ensureFunctionNamed: qualifiedNameNode name value inUnit: stack first ]
		ifNotNil: [ 
			"it means we have a method"
			importer ensureMethodNamed: qualifiedNameNode name value inType: (self localTypeNamed: (qualifiedNameNode namespace value)) ].	
	importer 
		createSourceAnchorFor: famixBehavior 
		fileName: fileName 
		start: aNode startPosition 
		end: aNode stopPosition.
	famixBehavior fkDelphiAST: aNode.
	famixBehavior isStub: false.
	self
		push: famixBehavior
		andDo: [ super visitMethodDefinition: aNode ].

]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitMethodHeader: aNode [
	| famixBehavior |
	isInterfaceSection ifFalse: [ ^ super visitMethodHeader: aNode ].
	"we only take this into account when it is in the interface section
	the implementation section is taken into account by the method definition node"
	famixBehavior := stack top isType 
			ifTrue: [ importer ensureMethodNamed: aNode qualifiedName name value inType: stack top ]
			ifFalse: [ importer ensureFunctionNamed: aNode qualifiedName name value inUnit: stack first ].
	famixBehavior isStub: false.
	famixBehavior fkDelphiAST: aNode.
	self 
		push: famixBehavior
		andDo: [ super visitMethodHeader: aNode ]
]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitModuleName: aNode [
	| association |
	aNode parent class = DelphiUnitFileNode ifFalse: [
		association := importer 
			createUsesAssociationFrom: stack top 
			withSignature: ('::' join: (aNode names collect: #value)).
		association isInterface: (aNode parent class = DelphiInterfaceSectionNode) ]. 
	super visitModuleName: aNode
]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitNamedDefinedType: aNode [
	| famixType |
	famixType := nil.
	(aNode type isKindOf: DelphiClassOrInterfaceTypeNode) ifTrue: [  
		famixType := importer ensureClassNamed: aNode name value inUnit: stack first ].
	(aNode type isKindOf: DelphiRecordTypeNode) ifTrue: [  
		famixType := importer ensureRecordNamed: aNode name value inUnit: stack first ].	
	famixType isNil 
		ifTrue: [ super visitNamedDefinedType: aNode ]
		ifFalse: [
			importer 
				createSourceAnchorFor: famixType 
				fileName: fileName 
				start: aNode startPosition 
				end: aNode stopPosition.
			famixType fkDelphiAST: aNode.
			famixType isStub: false.
			self 
				push: famixType 
				andDo: [ super visitNamedDefinedType: aNode ] ]
]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitProgramFile: aNode [
	| namespace famixProgram |
	namespace := nil.
"	aNode programName value do: [ :each | 
		namespace := importer 
			ensureNamespaceNamed: each value 
			inNamespace: namespace ]."
	famixProgram := importer 
		ensureProgramNamed: aNode programName value
		inNamespace: namespace.
	famixProgram isStub: false.
	famixProgram fkDelphiAST: aNode.
	importer 
		createSourceAnchorFor: famixProgram 
		fileName: fileName 
		start: aNode startPosition 
		end: aNode stopPosition.
	^ self 
		push: famixProgram
		andDo: [ super visitProgramFile: aNode ]
]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitUnitFile: aUnit [
	| namespace famixUnit |
	namespace := nil.
	aUnit unitName names allButLast do: [ :each | 
		namespace := importer 
			ensureNamespaceNamed: each value 
			inNamespace: namespace ].
	famixUnit := importer 
		ensureUnitNamed: aUnit unitName names last value
		inNamespace: namespace.
	famixUnit isStub: false.
	famixUnit fkDelphiAST: aUnit.
	importer 
		createSourceAnchorFor: famixUnit 
		fileName: fileName 
		start: aUnit startPosition 
		end: aUnit stopPosition.
	self 
		push: famixUnit
		andDo: [ super visitUnitFile: aUnit ].
	^ famixUnit
]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitVariable: aNode [
	isInterfaceSection 
		ifTrue: [ 
			(aNode parentOfType: DelphiNewClassTypeNode)
				ifNil: [ 
					"it means we are defining a scoped variable"
					aNode names do: [ :each | 
						| variable |
						variable := importer ensureUnitVariable: each value inUnit: stack first.
						variable isStub: false.
						variable fkDelphiAST: aNode ]. ]
				ifNotNil: [
					"it means we are defining an attribute"
					aNode names do: [ :each | 
						| variable |
						variable := importer ensureAttributeNamed: each value inType: stack top.
						variable isStub: false.
						variable fkDelphiAST: aNode ].
			] ]
		ifFalse: [
			(stack top isBehaviouralEntity)
				ifFalse: [ 
					aNode names do: [ :each | 
						| variable |
						variable := importer ensureUnitVariable: each value inUnit: stack first.
						variable isStub: false.
						variable fkDelphiAST: aNode ]. ]
				ifTrue: [ 
					aNode names do: [ :each | 
						| variable |
						variable := importer ensureLocalVariableNamed: each value inBehavior: stack top.
						variable isStub: false.
						variable fkDelphiAST: aNode ].
					 ]
			].
	super visitVariable: aNode
]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitVariableDefinition: aNode [
	"this is an attribute of a type"
	| famixAttribute |
	aNode names do: [ :each | 
		famixAttribute := importer ensureAttributeNamed: each value inType: stack top.
		famixAttribute isStub: false.
		famixAttribute fkDelphiAST: aNode ].
	
	super visitVariableDefinition: aNode 
]

{ #category : #visiting }
FKDelphiPasStructureVisitor >> visitVariableExpression: aNode [
	| invocation |
	aNode parent class = DelphiStatementBlockNode	
		ifTrue: [ 
			"simple procedure or function calls look like a Variable Expression"
			invocation := importer 
				createBasicInvocationsFromBehavior: stack top
				toFunctionNamed: aNode name value.
			invocation fkDelphiAST: aNode ]
		ifFalse: [
			((aNode parentOfType: DelphiAssignmentExpressionNode) notNil 
				and: [(aNode parentOfType: DelphiAssignmentExpressionNode) lhs ~~ aNode])  ifTrue: [
				"we exclude the case when we are on the left hand side of an assignment
				because this is a write access"
				| access |
				access := importer createBasicAccessFromBehavior: stack top.
				access isWrite: false.
				access fkDelphiAST: aNode. ] ]. 
	super visitVariableExpression: aNode 
]
