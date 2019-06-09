Class {
	#name : #FKDelphiImporter,
	#superclass : #Object,
	#instVars : [
		'targetModel',
		'units',
		'namespaces',
		'methods',
		'functions',
		'attributes',
		'programs',
		'parameters',
		'scopedVariables',
		'localVariables',
		'records',
		'classes',
		'unknownTypes'
	],
	#category : #'GToolkit4Famix3-Delphi-Importer'
}

{ #category : #creating }
FKDelphiImporter >> createBasicAccessFromBehavior: aFAMIXFunction [ 
	| access |
	access := FAMIXAccess new accessor: aFAMIXFunction.
	targetModel add: access.
	^ access
]

{ #category : #creating }
FKDelphiImporter >> createBasicInheritanceFromType: aFamixType [ 
	| inheritance |
	inheritance := FAMIXInheritance new subclass: aFamixType.
	targetModel add: inheritance.
	^ inheritance
]

{ #category : #creating }
FKDelphiImporter >> createBasicInvocationsFromBehavior: aFAMIXFunction toFunctionNamed: aString [ 
	| invocation |
	invocation := FAMIXInvocation new 
		sender: aFAMIXFunction;
		signature: aString.
	targetModel add: invocation.
	^ invocation
]

{ #category : #creating }
FKDelphiImporter >> createSourceAnchorFor: anEntity fileName: aString start: startPosition end: stopPosition [
	| sourceAnchor |
	sourceAnchor := FAMIXIndexedFileAnchor new 
		startPos: startPosition; 
		endPos: stopPosition; 
		fileName: aString.
	targetModel add: sourceAnchor.
	anEntity sourceAnchor: sourceAnchor.
]

{ #category : #creating }
FKDelphiImporter >> createUnitNamed: aString [
	^ FKDelphiUnit new name: aString; isStub: true
]

{ #category : #creating }
FKDelphiImporter >> createUsesAssociationFrom: aUnit withSignature: aString [
	| usesAssociation |
	usesAssociation := FKDelphiUnitUsesAssociation new.
	usesAssociation signature: aString.
	usesAssociation userUnit: aUnit.
	usesAssociation usedUnit: (self ensureUnitNamed: aString).
	targetModel add: usesAssociation.
	^ usesAssociation
]

{ #category : #ensuring }
FKDelphiImporter >> ensureAttributeNamed: aString inType: aFamixType [
	^ self 
		in: attributes 
		at: (self qualifiedNameWith: aFamixType mooseName and: aString)
		ifAbsentPut: [ FAMIXAttribute new name: aString; parentType: aFamixType; isStub: true ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureClassNamed: aString inUnit: unit [
	^ self 
		in: classes 
		at: (self qualifiedNameWith: unit mooseName and: aString)
		ifAbsentPut: [ 	FAMIXClass new name: aString; container: unit; isStub: true ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureConstant: aString inType: aType [
	^ self 
		in: scopedVariables 
		at: (self qualifiedNameWith: aType mooseName and: aString)
		ifAbsentPut: [ FKDelphiConstantAttribute new name: aString; parentType: aType; isStub: true ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureConstant: aString inUnit: aUnit [
	^ self 
		in: attributes 
		at: (self qualifiedNameWith: aUnit mooseName and: aString)
		ifAbsentPut: [ FKDelphiUnitConstant new name: aString; parentScope: aUnit; isStub: true ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureFunctionNamed: aString inUnit: aFamixUnit [
	^ self 
		in: functions 
		at: (self qualifiedNameWith: aFamixUnit mooseName and: aString)
		ifAbsentPut: [ FAMIXFunction new name: aString; container: aFamixUnit; isStub: true ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureLocalVariableNamed: aString inBehavior: aFamixBehavior [
	^ self 
		in: localVariables 
		at: (self qualifiedNameWith: aFamixBehavior mooseName and: aString)
		ifAbsentPut: [ FAMIXLocalVariable new name: aString; parentBehaviouralEntity: aFamixBehavior ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureMethodNamed: aString inType: aFamixType [
	^ self 
		in: methods 
		at: (self qualifiedNameWith: aFamixType mooseName and: aString)
		ifAbsentPut: [ FAMIXMethod new name: aString; parentType: aFamixType ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureNamespaceNamed: aString inNamespace: aFamixNamespace [
	| qualifiedName |
	qualifiedName := aFamixNamespace
		ifNil: [ aString ]
		ifNotNil: [ self qualifiedNameWith: aFamixNamespace mooseName and: aString ].
	^ self 
		in: namespaces
		at: qualifiedName
		ifAbsentPut: [ FAMIXNamespace new name: aString; parentScope: aFamixNamespace ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureParameterNamed: aString inBehavior: aFamixBehavior [
	^ self 
		in: parameters
		at: (self qualifiedNameWith: aFamixBehavior mooseName and: aString)
		ifAbsentPut: [ FAMIXParameter new name: aString; parentBehaviouralEntity: aFamixBehavior ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureProgramNamed: aString inNamespace: aFamixNamespace [
	| qualifiedName |
	qualifiedName := aFamixNamespace
		ifNil: [ aString ]
		ifNotNil: [ self qualifiedNameWith: aFamixNamespace mooseName and: aString ].
	^ self 
		in: programs 
		at: qualifiedName
		ifAbsentPut: [ FKDelphiProgram new name: aString; parentScope: aFamixNamespace ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureRecordNamed: aString inUnit: unit [
	^ self 
		in: records
		at: (self qualifiedNameWith: unit mooseName and: aString)
		ifAbsentPut: [ 	FKDelphiRecord new name: aString; container: unit ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureTypeNamed: aString inUnit: unit [
	^ self 
		in: types 
		at: (unit mooseName, '::', aString)
		ifAbsentPut: [ 	FAMIXClass new name: aString; container: unit ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureUnitNamed: aString [
	^ self 
		in: units 
		at: aString
		ifAbsentPut: [ FKDelphiUnit new name: aString; isStub: true ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureUnitNamed: aString inNamespace: aFamixNamespace [
	| qualifiedName |
	qualifiedName := aFamixNamespace
		ifNil: [ aString ]
		ifNotNil: [ self qualifiedNameWith: aFamixNamespace mooseName and: aString ].
	^ self 
		in: units 
		at: qualifiedName
		ifAbsentPut: [ (self createUnitNamed: aString) parentScope: aFamixNamespace ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureUnitVariable: aString inUnit: aUnit [
	^ self 
		in: scopedVariables 
		at: (self qualifiedNameWith: aUnit mooseName and: aString)
		ifAbsentPut: [ FKDelphiUnitVariable new name: aString; parentScope: aUnit; isStub: true ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureUnknownTypeNamed: aString inUnit: aFamixUnit [
	^ self 
		in: unknownTypes
		at: (self qualifiedNameWith: aFamixUnit mooseName and: aString)
		ifAbsentPut: [ FAMIXType new name: aString; container: aFamixUnit; isStub: true ]
]

{ #category : #importing }
FKDelphiImporter >> importAll: aCollectionOfPasFiles relativeTo: aDirectory [
	aCollectionOfPasFiles 
		do: [ :each | self importPasOrDprFile: each relativeTo: aDirectory ]
		displayingProgress: 'Importing .pas files'.
	self resolveAssociations
]

{ #category : #importing }
FKDelphiImporter >> importDirectory: aDirectory [
	aDirectory allFiles
		do: [ :each | 
			"[ "
				(each extension = 'pas' or: [ each extension = 'dpr' ]) 
					ifTrue: [ self importPasOrDprFile: each relativeTo: aDirectory ].
			"] on: Error do: [ :error | (each -> error) asBeaconSignal emit ]" ]
		displayingProgress: 'Importing .pas files'.
	targetModel rootFolder: aDirectory.
	self resolveAssociations.
	self populateModel
]

{ #category : #importing }
FKDelphiImporter >> importPasOrDprFile: aFile relativeTo: aDirectory [
	| visitor famixUnit dfmFile |
	visitor := FKDelphiPasStructureVisitor new 
		fileName: (String streamContents: [:s | 
			(aFile relativeTo: aDirectory)
				printOn: s 
				delimiter: $/ ]); 
		importer: self.
	famixUnit := aFile fkDelphiAST acceptVisitor: visitor.
	dfmFile := aFile withExtension: 'dfm'.
	dfmFile exists ifTrue: [
		| formVisitor |
		formVisitor := FKDelphiFormVisitor new 
			importer: self; 
			unit: famixUnit;
			fileName: (String streamContents: [:s | 
			(dfmFile relativeTo: aDirectory)
				printOn: s 
				delimiter: $/ ]).
		[dfmFile fkDelphiFormAST acceptVisitor: formVisitor] on: UTF8InvalidText do: [ :err | err emit ]
	]
]

{ #category : #importing }
FKDelphiImporter >> importProject: dpr [
	| unitFiles |
	unitFiles := ((dpr fkDelphiAST filenames collect: [ :filename | dpr parent resolve: (filename value copyReplaceAll: '\' with: '/' ) allButFirst allButLast ]) collectAsSet: #fullName) collect: #asFileReference.
	self importPasOrDprFile: dpr relativeTo: dpr parent.
	unitFiles do: [ :file | self importPasOrDprFile: file relativeTo: dpr parent ].
	self targetModel rootFolder: dpr parent.
	self targetModel name: dpr basename.
	self resolveAssociations.
	self populateModel.
	^ self targetModel.

]

{ #category : #utilities }
FKDelphiImporter >> in: aDictionary at: aKey ifAbsentPut: aBlock [
	^ aDictionary
		at: aKey asLowercase
		ifAbsentPut: aBlock
]

{ #category : #utilities }
FKDelphiImporter >> in: aDictionary at: aKey ifPresent: aBlock [
	^ aDictionary
		at: aKey asLowercase
		ifPresent: aBlock
]

{ #category : #utilities }
FKDelphiImporter >> in: aDictionary at: aKey ifPresent: aBlock ifAbsent: anotherBlock [
	^ aDictionary
		at: aKey asLowercase
		ifPresent: aBlock
		ifAbsent: anotherBlock
]

{ #category : #initialize }
FKDelphiImporter >> initialize [
	super initialize.
	targetModel := MooseModel new.
	units := Dictionary new.
	programs := Dictionary new.
	namespaces := Dictionary new.
	classes := Dictionary new.
	methods := Dictionary new.
	functions := Dictionary new.
	attributes := Dictionary new.
	scopedVariables := Dictionary new.
	parameters := Dictionary new.
	localVariables := Dictionary new.
	records := Dictionary new.
	unknownTypes := Dictionary new
]

{ #category : #importing }
FKDelphiImporter >> populateModel [
	targetModel 
		addAll: namespaces values;
		addAll: classes values;
		addAll: methods values;
		addAll: units values;
		addAll: programs values;
		addAll: functions values;
		addAll: attributes values;
		addAll: scopedVariables values;
		addAll: parameters values;
		addAll: localVariables values;
		addAll: records values
]

{ #category : #accessing }
FKDelphiImporter >> programs [
	^ programs
]

{ #category : #accessing }
FKDelphiImporter >> programs: anObject [
	programs := anObject
]

{ #category : #utilities }
FKDelphiImporter >> qualifiedNameWith: aString and: anotherString [
	^ aString asLowercase, '.', anotherString asLowercase
]

{ #category : #importing }
FKDelphiImporter >> resolveAccess: anAccess [
	| ast variable nestedNames |
	ast := anAccess fkDelphiAST.
	self flag: 'deal with the rest of the types'.
	ast class = DelphiVariableExpressionNode ifTrue: [
		variable := anAccess accessor lookupVariableNamed: ast name value.
		anAccess variable: variable ].
	ast class = DelphiPropertyExpressionNode ifTrue: [ 
		nestedNames := ast 
			withDeep: [ :node | DelphiPropertyExpressionNode == node class ifTrue: [ node expression ] ifFalse: [ {} ] ] 
			collect: [:node | node name value].
		variable := anAccess accessor lookupVariableWithNames: nestedNames reversed.
		anAccess variable: variable ]
]

{ #category : #importing }
FKDelphiImporter >> resolveAssociations [
	classes do: [ :type | self resolveInheritancesFor: type ].
	parameters do: [ :p | self resolveDeclaredTypeFor: p ].
	functions do: [ :f | self resolveDeclaredTypeFor: f ].
	attributes do: [ :a | self resolveDeclaredTypeFor: a ].
	localVariables do: [ :a | self resolveDeclaredTypeFor: a ].
	scopedVariables do: [ :a | self resolveDeclaredTypeFor: a ].
	methods do: [ :m | self resolveDeclaredTypeFor: m ].
	(targetModel allDelphiFormObjects select: [:object | object isRoot]) 
		do: [ :object | self resolveObjectTargetEntitiesFor: object ].
	targetModel allInvocations do: [ :invocation | self resolveInvocation: invocation ].
"	targetModel allAccesses do: [ :access | self resolveAccess: access ]"
]

{ #category : #importing }
FKDelphiImporter >> resolveAssociationsFor: aScopingEntity [
	aScopingEntity outgoingUsesAssociations do: [ :assoc | 
		assoc usedUnit: (self ensureUnitNamed: assoc signature) ]	
]

{ #category : #importing }
FKDelphiImporter >> resolveDeclaredTypeFor: anEntityWithDeclaredType [
	| declaredTypeNode declaredTypeName famixType |
	anEntityWithDeclaredType fkDelphiAST ifNil: [ ^ self ].
	declaredTypeNode := anEntityWithDeclaredType fkDelphiAST type.
	declaredTypeNode ifNil: [ ^ self ].
	declaredTypeNode class = DelphiNamedTypeNode ifTrue: [ 
		declaredTypeName := declaredTypeNode typeExpression name value.
		famixType := anEntityWithDeclaredType namespaceScope lookupTypeNamed: declaredTypeName.
		famixType := famixType ifNil: [ self ensureClassNamed: declaredTypeName inUnit: self unknownUnit ].
		anEntityWithDeclaredType declaredType: famixType ].
	self flag: 'Deal with generic type'
]

{ #category : #importing }
FKDelphiImporter >> resolveInheritancesFor: aType [
	aType isStub ifTrue: [ ^ self ].
	aType fkDelphiAST type superclasses do: [ :superclass | 
		| famixSuperType famixInheritance |
		famixInheritance := self createBasicInheritanceFromType: aType.
		famixSuperType := aType parentScope lookupTypeNamed: superclass name value. 
		famixSuperType := famixSuperType ifNil: [ self ensureClassNamed: superclass name value inUnit: self unknownUnit ].
		famixInheritance superclass: famixSuperType.
		famixInheritance fkDelphiAST: superclass
	]
]

{ #category : #importing }
FKDelphiImporter >> resolveInvocation: anInvocation [
	| receiver |
	receiver := anInvocation fkDelphiAST receiver.
	(receiver class = DelphiPropertyExpressionNode and: [receiver expression class = DelphiVariableExpressionNode]) ifTrue: [ 
		self 
			in: functions 
			at: (receiver expression name value, '.', receiver name value)
			ifPresent: [ :candidate | anInvocation addCandidate: candidate ] 
			ifAbsent: [  ] ].
	receiver class = DelphiVariableExpressionNode ifTrue: [ 
		(anInvocation sender lookupFunctionNamed: receiver name value) ifNotNil: [ :candidate |
			anInvocation addCandidate: candidate ] ].
]

{ #category : #importing }
FKDelphiImporter >> resolveObjectTargetEntitiesFor: anObject [
	anObject 
		deep: [:each | each objects ] 
		do: [ :each | 
			| targetEntity attributeName |
			attributeName := each fkDelphiAST nameToken value.
			attributeName := attributeName ifNil: [ '__UNKNOWN__' ].
			targetEntity := each topParentObject targetEntity declaredType lookupVariableNamed: attributeName.
			targetEntity := targetEntity ifNil: [ 
					(self
						ensureAttributeNamed: attributeName 
						inType: each parentObject targetEntity declaredType)
						declaredType: self unknownType ].
			each targetEntity: targetEntity ]
]

{ #category : #accessing }
FKDelphiImporter >> targetModel [
	^ targetModel
]

{ #category : #accessing }
FKDelphiImporter >> targetModel: anObject [
	targetModel := anObject
]

{ #category : #ensuring }
FKDelphiImporter >> unknownType [
	^ self ensureUnknownTypeNamed: '__UNKNOWN__' inUnit: self unknownUnit
]

{ #category : #ensuring }
FKDelphiImporter >> unknownUnit [
	^ self ensureUnitNamed: FKDelphiUnit unknownUnitName
]
