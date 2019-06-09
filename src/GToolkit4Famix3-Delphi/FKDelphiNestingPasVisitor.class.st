Class {
	#name : #FKDelphiNestingPasVisitor,
	#superclass : #DelphiProgramNodeVisitor,
	#instVars : [
		'importer',
		'stack',
		'fileName'
	],
	#category : #'GToolkit4Famix3-Delphi-Importer'
}

{ #category : #accesing }
FKDelphiNestingPasVisitor >> fileName: aString [ 
	fileName := aString
]

{ #category : #accessing }
FKDelphiNestingPasVisitor >> importer [
	^ importer
]

{ #category : #accessing }
FKDelphiNestingPasVisitor >> importer: anObject [
	importer := anObject
]

{ #category : #initialize }
FKDelphiNestingPasVisitor >> initialize [
	stack := Stack new
]

{ #category : #private }
FKDelphiNestingPasVisitor >> push: anEntity andDo: aBlock [
	stack push: anEntity.
	aBlock value.
	stack pop
]

{ #category : #visiting }
FKDelphiNestingPasVisitor >> visitMethodHeader: aNode [
	| famixBehavior  |
	famixBehavior := stack top isType 
		ifTrue: [ importer ensureMethodNamed: aNode qualifiedName name value inType: stack top ]
		ifFalse: [ importer ensureFunctionNamed: aNode qualifiedName name value inUnit: stack first ].
	importer 
		createSourceAnchorFor: famixBehavior 
		fileName: fileName 
		start: aNode startPosition 
		end: aNode stopPosition.
	self
		push: famixBehavior 
		andDo: [ super visitMethodHeader: aNode ].
	^ famixBehavior
]

{ #category : #visiting }
FKDelphiNestingPasVisitor >> visitModuleName: aNode [
	| association |
	aNode parent class = DelphiUnitFileNode ifFalse: [
		association := importer 
			createUsesAssociationFrom: stack top 
			withSignature: ('::' join: (aNode names collect: #value)).
		association isInterface: (aNode parent class = DelphiInterfaceSectionNode) ]. 
	super visitModuleName: aNode
]

{ #category : #visiting }
FKDelphiNestingPasVisitor >> visitNamedDefinedType: aNode [
	| famixType |
	famixType := importer ensureTypeNamed: aNode name value inUnit: stack first.
	importer 
		createSourceAnchorFor: famixType 
		fileName: fileName 
		start: aNode startPosition 
		end: aNode stopPosition.
	self 
		push: famixType 
		andDo: [ super visitNamedDefinedType: aNode ]
]

{ #category : #visiting }
FKDelphiNestingPasVisitor >> visitProgramFile: aNode [
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
FKDelphiNestingPasVisitor >> visitUnitFile: aUnit [
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
	importer 
		createSourceAnchorFor: famixUnit 
		fileName: fileName 
		start: aUnit startPosition 
		end: aUnit stopPosition.
	^ self 
		push: famixUnit
		andDo: [ super visitUnitFile: aUnit ]
]

{ #category : #visiting }
FKDelphiNestingPasVisitor >> visitVariableDefinition: aNode [
	"this is an attribute of a type"
	aNode names do: [ :each | 
		importer ensureAttributeNamed: each value inType: stack top ].
	super visitVariable: aNode 
]
