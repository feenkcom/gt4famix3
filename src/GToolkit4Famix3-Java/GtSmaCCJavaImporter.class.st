Class {
	#name : #GtSmaCCJavaImporter,
	#superclass : #Object,
	#instVars : [
		'model',
		'rootNamespaces',
		'folders',
		'primitiveTypes',
		'typeClass',
		'javaLang',
		'specificImports',
		'baseDirectory',
		'asts'
	],
	#category : #'GToolkit4Famix3-Java'
}

{ #category : #accessing }
GtSmaCCJavaImporter >> addAnnotationTypes [
	self
		javaAstsDo: [ :node | 
			node
				withAllNodesOfType: JavaAnnotationNode
				do: [ :each | (self entitiesIn: each) do: [ :entity | self lookupAnnotatedType: each name ] ] ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> addInheritedTypes [
	model allTypes
		do: [ :each | 
			(each propertyNamed: #ast ifAbsent: [  ])
				ifNotNil: [ :ast | 
					((ast isKindOf: JavaAnnotationInterfaceNode)
						or: [ ast isKindOf: JavaTypeParameterNode ])
						ifFalse: [ (ast isKindOf: JavaClassDeclarationNode)
								ifTrue: [ ast superclass
										ifNotNil: [ (self lookupType: ast superclass name)
												ifNotNil: [ :superType | 
													| inheritance |
													inheritance := FAMIXInheritance new
															subclass: each;
															superclass: superType;
															sourceAnchor: (self sourceAnchorFor: ast superclass);
															propertyNamed: #ast put: ast superclass;
															yourself.
													model add: inheritance.
													each addSuperInheritance: inheritance ] ] ].
							((ast isKindOf: JavaInterfaceDeclarationNode)
								ifTrue: [ ast interfaceTypes ]
								ifFalse: [ ast interfaces ])
								do: [ :intf | 
									(self lookupType: intf name)
										ifNotNil: [ :superType | 
											| inheritance |
											inheritance := FAMIXInheritance new
													subclass: each;
													superclass: superType;
													sourceAnchor: (self sourceAnchorFor: intf);
													propertyNamed: #ast put: intf;
													yourself.
											model add: inheritance.
											each addSuperInheritance: inheritance ] ] ] ] ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> addMethodSignature: method [
	method
		signature: (String
				streamContents: [ :stream | 
					stream << method name << '('.
					method parameters
						do: [ :each | stream << (each declaredType ifNil: [ each name ] ifNotNil: [ :t | t name ]) ]
						separatedBy: [ stream << ', ' ].
					stream << ')' ])
]

{ #category : #accessing }
GtSmaCCJavaImporter >> addModifiers: aCollection to: anEntity [
	aCollection
		do: [ :each | 
			(each isKindOf: JavaModifierNode)
				ifTrue: [ anEntity addModifier: each token source asSymbol ] ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> addParameterTypes: aNode to: anEntity [
	aNode ifNil: [ ^ self ].
	aNode parameters
		do: [ :each | 
			| type |
			type := FAMIXParameterType new
					name: each name source;
					container: anEntity;
					sourceAnchor: (self sourceAnchorFor: each);
					mooseModel: model;
					yourself.
			(aNode topParent attributeNamed: #famixFile) addEntity: type.
			type propertyNamed: #ast put: each.
			each attributeNamed: #container put: type ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> baseDirectory [
	^ baseDirectory
]

{ #category : #accessing }
GtSmaCCJavaImporter >> baseDirectory: anObject [
	baseDirectory := anObject asFileReference
]

{ #category : #accessing }
GtSmaCCJavaImporter >> buildJavaLangTypes [
	javaLang := self ensureNamespace: 'lang' in: (self ensureRootNamespace: 'java').
	typeClass := FAMIXAnnotationType.
	#(#Deprecated #FunctionalInterface #Override #SafeVarargs #SuppressWarnings)
		do: [ :each | 
			| parts ns |
			ns := javaLang.
			parts := each substrings: '.'.
			parts
				do: [ :part | (ns := self lookupTypeNamed: part inContainer: ns) isStub: true ] ].
	typeClass := FAMIXType.
	#('AbstractMethodError' 'Appendable' 'ArithmeticException' 'ArrayIndexOutOfBoundsException' 'ArrayStoreException' 'AssertionError' 'AutoCloseable' 'Boolean' 'BootstrapMethodError' 'Byte' 'Character' 'Character.Subset' 'Character.UnicodeBlock' 'Character.UnicodeScript' 'CharSequence' 'Class' 'ClassCastException' 'ClassCircularityError' 'ClassFormatError' 'ClassLoader' 'ClassNotFoundException' 'ClassValue' 'Cloneable' 'CloneNotSupportedException' 'Comparable' 'Compiler' 'Double' 'Enum' 'EnumConstantNotPresentException' 'Error' 'Exception' 'ExceptionInInitializerError' 'Float' 'IllegalAccessError' 'IllegalAccessException' 'IllegalArgumentException' 'IllegalMonitorStateException' 'IllegalStateException' 'IllegalThreadStateException' 'IncompatibleClassChangeError' 'IndexOutOfBoundsException' 'InheritableThreadLocal' 'InstantiationError' 'InstantiationException' 'Integer' 'InternalError' 'InterruptedException' 'Iterable' 'LinkageError' 'Long' 'Math' 'NegativeArraySizeException' 'NoClassDefFoundError' 'NoSuchFieldError' 'NoSuchFieldException' 'NoSuchMethodError' 'NoSuchMethodException' 'NullPointerException' 'Number' 'NumberFormatException' 'Object' 'OutOfMemoryError' 'Package' 'Process' 'ProcessBuilder' 'ProcessBuilder.Redirect' 'ProcessBuilder.Redirect.Type' 'Readable' 'ReflectiveOperationException' 'Runnable' 'Runtime' 'RuntimeException' 'RuntimePermission' 'SecurityException' 'SecurityManager' 'Short' 'StackOverflowError' 'StackTraceElement' 'StrictMath' 'String' 'StringBuffer' 'StringBuilder' 'StringIndexOutOfBoundsException' 'System' 'Thread' 'Thread.State' 'Thread.UncaughtExceptionHandler' 'ThreadDeath' 'ThreadGroup' 'ThreadLocal' 'Throwable' 'TypeNotPresentException' 'UnknownError' 'UnsatisfiedLinkError' 'UnsupportedClassVersionError' 'UnsupportedOperationException' 'VerifyError' 'VirtualMachineError' 'Void')
		do: [ :each | 
			| parts ns |
			ns := javaLang.
			parts := each substrings: '.'.
			parts
				do: [ :part | (ns := self lookupTypeNamed: part inContainer: ns) isStub: true ] ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> buildJavaModel [
	model := MooseModel new.
	model sourceLanguage: FAMIXJavaSourceLanguage new.
	model rootFolder: baseDirectory.
	model name: baseDirectory basenameWithoutExtension.
	self buildSpecificImports.
	self buildJavaLangTypes.
	self importFiles.
	self importNamespaces.
	self importInterfaces.
	self importClasses.
	self importRecords.
	self importEnums.
	self addInheritedTypes.
	self addAnnotationTypes.
	self importClassParts.
	self importAnnotations.
	self importMethodSource.
	^ model
]

{ #category : #accessing }
GtSmaCCJavaImporter >> buildSpecificImports [
	specificImports := Dictionary new.
	self
		javaAstsDo: [ :node | 
			node imports
				do: [ :each | 
					(each class = JavaSingleTypeImportDeclarationNode
						and: [ each staticToken isNil ])
						ifTrue: [ (specificImports at: each name nspace ifAbsentPut: [ Set new ])
								add: each name name source ] ] ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> containerIn: aNode [
	| current |
	current := aNode.
	[ current notNil ]
		whileTrue: [ (current attributeNamed: #container ifAbsent: [  ]) ifNotNil: [ :c | ^ c ].
			current := current parent ].
	^ nil
]

{ #category : #accessing }
GtSmaCCJavaImporter >> containerIn: aNode matching: aBlock [
	| current |
	current := aNode.
	[ current notNil ]
		whileTrue: [ (current attributeNamed: #container ifAbsent: [  ])
				ifNotNil: [ :c | (aBlock value: c) ifTrue: [ ^ c ] ].
			current := current parent ].
	^ nil
]

{ #category : #accessing }
GtSmaCCJavaImporter >> createAnnotationTypeFrom: aNode [
	| type |
	type := FAMIXAnnotationType new
			name: aNode name source;
			container: (self containerIn: aNode parent);
			sourceAnchor: (self sourceAnchorFor: aNode);
			mooseModel: model;
			yourself.
	self addModifiers: aNode modifiers to: type.
	(aNode topParent attributeNamed: #famixFile) addEntity: type.
	type propertyNamed: #ast put: aNode.
	aNode attributeNamed: #container put: type.
	^ type
]

{ #category : #accessing }
GtSmaCCJavaImporter >> createClassOrInterfaceFrom: aNode [
	| class |
	class := FAMIXClass new
			name: aNode name source;
			container: (self containerIn: aNode parent);
			sourceAnchor: (self sourceAnchorFor: aNode);
			mooseModel: model;
			yourself.
	self addParameterTypes: aNode typeParameters to: class.
	self addModifiers: aNode modifiers to: class.
	(aNode topParent attributeNamed: #famixFile) addEntity: class.
	class propertyNamed: #ast put: aNode.
	aNode attributeNamed: #container put: class.
	^ class
]

{ #category : #accessing }
GtSmaCCJavaImporter >> createEnumFrom: aNode [
	| enum famixFile |
	enum := FAMIXEnum new
			name: aNode name source;
			container: (self containerIn: aNode parent);
			sourceAnchor: (self sourceAnchorFor: aNode);
			mooseModel: model;
			yourself.
	self addModifiers: aNode modifiers to: enum.
	famixFile := aNode topParent attributeNamed: #famixFile.
	famixFile addEntity: enum.
	enum propertyNamed: #ast put: aNode.
	aNode attributeNamed: #container put: enum.
	aNode constants
		do: [ :each | 
			| value |
			value := FAMIXEnumValue new
					name: each name source;
					parentEnum: enum;
					sourceAnchor: (self sourceAnchorFor: each);
					propertyNamed: #ast put: each;
					mooseModel: model;
					yourself.
			famixFile addEntity: value.
			each attributeNamed: #enumValue put: value ].
	^ enum
]

{ #category : #accessing }
GtSmaCCJavaImporter >> createUnknownType: name in: ns [
	^ (typeClass ifNil: [ FAMIXType ]) new
		name: name;
		isStub: true;
		mooseModel: model;
		container: ns;
		yourself
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureCatchVariables: aNode [
	| var famixFile type methodNodeVars |
	famixFile := aNode topParent attributeNamed: #famixFile.
	methodNodeVars := aNode attributeNamed: #locals ifAbsentPut: [ Dictionary new ].
	type := aNode parameter types size > 1
			ifTrue: [ model entityNamed: 'java::lang::Exception' ]
			ifFalse: [ self typeFrom: aNode parameter types first ].
	var := FAMIXLocalVariable new
			name: aNode parameter variable source;
			sourceAnchor: (self sourceAnchorFor: aNode parameter);
			parentBehaviouralEntity: (self containerIn: aNode parent);
			declaredType: type;
			mooseModel: model;
			propertyNamed: #ast put: aNode parameter;
			yourself.
	methodNodeVars at: var name put: var.
	famixFile addEntity: var
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureConstructorFrom: methodNode [
	| method container famixFile |
	container := self containerIn: methodNode parent.
	famixFile := methodNode topParent attributeNamed: #famixFile.
	method := FAMIXMethod new
			name: container name;
			sourceAnchor: (self sourceAnchorFor: methodNode);
			parentType: container;
			isConstructor: true;
			mooseModel: model;
			propertyNamed: #ast put: methodNode;
			yourself.
	self addModifiers: methodNode modifiers to: method.
	self addParameterTypes: methodNode typeParameters to: method.
	famixFile addEntity: method.
	methodNode attributeNamed: #container put: method.
	methodNode parameters
		do: [ :each | 
			| parm |
			parm := FAMIXParameter new
					declaredType: (self typeFrom: each type);
					name: each variable source;
					sourceAnchor: (self sourceAnchorFor: each);
					mooseModel: model;
					propertyNamed: #ast put: each;
					belongsTo: method;
					yourself.
			(methodNode attributeNamed: #locals ifAbsentPut: [ Dictionary new ])
				at: parm name
				put: parm.
			each attributeNamed: #entity put: parm.
			famixFile addEntity: parm ].
	self addMethodSignature: method.
	^ method
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureFieldFrom: fieldNode [
	| attr famixFile |
	famixFile := fieldNode topParent attributeNamed: #famixFile.
	fieldNode
		attributeNamed: #entities
		put: (fieldNode variableDeclarations
				collect: [ :each | 
					attr := FAMIXAttribute new
							name: each variable name source;
							sourceAnchor: (self sourceAnchorFor: fieldNode);
							parentType: (self containerIn: fieldNode parent);
							declaredType: (self typeFrom: fieldNode type);
							mooseModel: model;
							propertyNamed: #ast put: each;
							yourself.
					self addModifiers: fieldNode modifiers to: attr.
					famixFile addEntity: attr.
					attr ]).
	^ attr
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureFileFrom: aFileReference [
	| file anchor |
	file := FAMIXFile new.
	file name: aFileReference basename.
	anchor := FAMIXIndexedFileEntityAnchor
			file: file
			startPos: 1
			endPos: aFileReference contents size
			model: model.
	file sourceAnchor: anchor.
	(self ensureFolderNamed: aFileReference parent)
		ifNotNil: [ :folder | folder addChildFileSystemEntity: file ].
	model add: file.
	^ file
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureFolderNamed: aDirectory [
	^ folders
		at: aDirectory pathString
		ifAbsentPut: [ | folder |
			folder := FAMIXFolder new.
			aDirectory = baseDirectory
				ifTrue: [ folder name: '.' ]
				ifFalse: [ folder name: aDirectory basename.
					(self ensureFolderNamed: aDirectory parent)
						ifNotNil: [ :outer | outer addChildFileSystemEntity: folder ] ].
			model add: folder.
			folder ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureForEachLocalVariable: aNode [
	| var famixFile type methodNodeVars |
	famixFile := aNode topParent attributeNamed: #famixFile.
	type := self typeFrom: aNode type.
	methodNodeVars := aNode attributeNamed: #locals ifAbsentPut: [ Dictionary new ].
	var := FAMIXLocalVariable new
			name: aNode name source;
			sourceAnchor: (self sourceAnchorFor: aNode name);
			parentBehaviouralEntity: (self containerIn: aNode parent);
			declaredType: type;
			mooseModel: model;
			propertyNamed: #ast put: aNode;
			yourself.
	methodNodeVars at: var name put: var.
	famixFile addEntity: var
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureInitializerFrom: aNode [
	| method famixFile container |
	container := self containerIn: aNode parent.
	famixFile := aNode topParent attributeNamed: #famixFile.
	method := FAMIXMethod new
			name: '$' , container name;
			sourceAnchor: (self sourceAnchorFor: aNode);
			addModifier: #static;
			parentType: container;
			mooseModel: model;
			propertyNamed: #ast put: aNode;
			yourself.
	famixFile addEntity: method.
	aNode attributeNamed: #container put: method.
	self addMethodSignature: method.
	^ method
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureInnerClassFrom: aNode [
	| class superType |
	superType := self lookupType: aNode type name.
	class := FAMIXClass new
			name: aNode type name name source;
			container: (self containerIn: aNode parent);
			sourceAnchor: (self sourceAnchorFor: aNode);
			mooseModel: model;
			propertyNamed: #ast put: aNode;
			yourself.
	(aNode topParent attributeNamed: #famixFile) addEntity: class.
	superType
		ifNotNil: [ | inheritance |
			inheritance := FAMIXInheritance new
					subclass: class;
					superclass: superType;
					sourceAnchor: (self sourceAnchorFor: aNode type);
					propertyNamed: #ast put: aNode type;
					mooseModel: model;
					yourself.
			class addSuperInheritance: inheritance ].
	aNode attributeNamed: #container put: class.
	^ class
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureInstanceofPatternVariable: aNode [
	| var famixFile type methodNodeVars |
	famixFile := aNode topParent attributeNamed: #famixFile.
	type := self typeFrom: aNode type.
	methodNodeVars := (aNode
			parentOfType: {JavaStatementNode.
					JavaConditionalExpressionNode.
					JavaSwitchExpressionNode})
			attributeNamed: #locals
			ifAbsentPut: [ Dictionary new ].
	var := FAMIXLocalVariable new
			name: aNode variable name source;
			sourceAnchor: (self sourceAnchorFor: aNode);
			parentBehaviouralEntity: (self containerIn: aNode parent);
			declaredType: type;
			mooseModel: model;
			propertyNamed: #ast put: aNode;
			yourself.
	methodNodeVars at: var name put: var.
	famixFile addEntity: var
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureLambdaFrom: aNode [
	| method famixFile |
	famixFile := aNode topParent attributeNamed: #famixFile.
	method := FAMIXFunction new
			name: '$' , aNode startPosition printString;
			container: (self containerIn: aNode parent);
			sourceAnchor: (self sourceAnchorFor: aNode);
			mooseModel: model;
			propertyNamed: #ast put: aNode;
			yourself.
	famixFile addEntity: method.
	aNode attributeNamed: #container put: method.
	aNode parameters
		do: [ :each | 
			| parm |
			parm := FAMIXParameter new
					name: each variable source;
					sourceAnchor: (self sourceAnchorFor: each);
					mooseModel: model;
					propertyNamed: #ast put: each;
					belongsTo: method;
					yourself.
			(aNode attributeNamed: #locals ifAbsentPut: [ Dictionary new ])
				at: parm name
				put: parm.
			each type ifNotNil: [ parm declaredType: (self typeFrom: each type) ].
			each attributeNamed: #entity put: parm.
			famixFile addEntity: parm ].
	self addMethodSignature: method.
	^ method
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureLocalVariables: aNode [
	| var famixFile type methodNodeVars |
	famixFile := aNode topParent attributeNamed: #famixFile.
	type := self typeFrom: aNode type.
	methodNodeVars := self localsFor: aNode.
	aNode variableDeclarations
		do: [ :each | 
			var := FAMIXLocalVariable new
					name: each variable source;
					sourceAnchor: (self sourceAnchorFor: each);
					parentBehaviouralEntity: (self containerIn: each parent);
					declaredType: type;
					mooseModel: model;
					propertyNamed: #ast put: each;
					yourself.
			methodNodeVars at: var name put: var.
			famixFile addEntity: var ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureMethodFrom: methodNode [
	| method famixFile |
	famixFile := methodNode topParent attributeNamed: #famixFile.
	method := FAMIXMethod new
			name: methodNode declarator name source;
			sourceAnchor: (self sourceAnchorFor: methodNode);
			parentType: (self containerIn: methodNode parent);
			declaredType: (self typeFrom: methodNode type);
			mooseModel: model;
			propertyNamed: #ast put: methodNode;
			yourself.
	self addModifiers: methodNode modifiers to: method.
	self addParameterTypes: methodNode typeParameters to: method.
	famixFile addEntity: method.
	methodNode attributeNamed: #container put: method.
	methodNode declarator parameters
		do: [ :each | 
			| parm |
			parm := FAMIXParameter new
					declaredType: (self typeFrom: each type);
					name: each variable source;
					sourceAnchor: (self sourceAnchorFor: each);
					mooseModel: model;
					propertyNamed: #ast put: each;
					belongsTo: method;
					yourself.
			(methodNode attributeNamed: #locals ifAbsentPut: [ Dictionary new ])
				at: parm name
				put: parm.
			each attributeNamed: #entity put: parm.
			famixFile addEntity: parm ].
	self addMethodSignature: method.
	^ method
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureNamespace: aString in: aNamespace [
	^ aNamespace childScopes
		detect: [ :each | each name = aString ]
		ifNone: [ model
				add: (FAMIXNamespace new
						name: aString;
						parentScope: aNamespace;
						yourself) ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureNamespaceFrom: aNode [
	(aNode class = JavaNameNode or: [ aNode class = JavaTypeNameNode ])
		ifTrue: [ ^ self ensureRootNamespace: aNode name source ].
	^ self
		ensureNamespace: aNode name source
		in: (self ensureNamespaceFrom: aNode nspace)
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureRecordMethodAndVariableFrom: parm [
	| attr famixFile method |
	famixFile := parm topParent attributeNamed: #famixFile.
	parm
		attributeNamed: #entities
		put: ({parm variable}
				collect: [ :each | 
					attr := FAMIXAttribute new
							name: each name source;
							sourceAnchor: (self sourceAnchorFor: parm);
							parentType: (self containerIn: parm parent);
							declaredType: (self typeFrom: parm type);
							mooseModel: model;
							propertyNamed: #ast put: each;
							yourself.
					famixFile addEntity: attr.
					attr ]).
	method := FAMIXMethod new
			name: parm variable name source;
			sourceAnchor: (self sourceAnchorFor: parm);
			parentType: (self containerIn: parm parent);
			declaredType: (self typeFrom: parm type);
			mooseModel: model;
			propertyNamed: #ast put: parm;
			yourself.
	famixFile addEntity: method.
	self addMethodSignature: method.
	^ attr
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureRootNamespace: aString [
	rootNamespaces ifNil: [ rootNamespaces := Dictionary new ].
	^ rootNamespaces
		at: aString
		ifAbsentPut: [ model
				add: (FAMIXNamespace new
						name: aString;
						yourself) ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureTryVariables: aNode [
	| var famixFile type methodNodeVars |
	famixFile := aNode topParent attributeNamed: #famixFile.
	methodNodeVars := aNode attributeNamed: #locals ifAbsentPut: [ Dictionary new ].
	aNode resources
		do: [ :res | 
			type := self typeFrom: res type.
			res variableDeclarations
				do: [ :each | 
					var := FAMIXLocalVariable new
							name: each variable source;
							sourceAnchor: (self sourceAnchorFor: each);
							parentBehaviouralEntity: (self containerIn: each parent);
							declaredType: type;
							mooseModel: model;
							propertyNamed: #ast put: each;
							yourself.
					methodNodeVars at: var name put: var.
					famixFile addEntity: var ] ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> ensureType: aJavaQualifiedNameNode [
	| ns name |
	name := aJavaQualifiedNameNode name source.
	ns := aJavaQualifiedNameNode nspace name source first isUppercase
			ifTrue: [ self lookupType: aJavaQualifiedNameNode nspace ]
			ifFalse: [ self ensureNamespaceFrom: aJavaQualifiedNameNode nspace ].
	^ self lookupTypeNamed: name inContainer: ns
]

{ #category : #accessing }
GtSmaCCJavaImporter >> entitiesIn: aNode [
	| current |
	current := aNode.
	[ current notNil ]
		whileTrue: [ (current
				attributeNamed: #entities
				ifAbsent: [ (current
						attributeNamed: #entity
						ifAbsent: [ current attributeNamed: #container ifAbsent: [  ] ])
						ifNotNil: [ :each | {each} ] ]) ifNotNil: [ :each | ^ each ].
			current := current parent ].
	^ nil
]

{ #category : #accessing }
GtSmaCCJavaImporter >> importAnnotations [
	self
		javaAstsDo: [ :node | 
			node
				withAllNodesOfType: JavaAnnotationNode
				do: [ :each | 
					(self entitiesIn: each)
						do: [ :entity | 
							(node attributeNamed: #famixFile)
								addEntity: (FAMIXAnnotationInstance new
										annotationType: (self lookupAnnotatedType: each name);
										annotatedEntity: entity;
										mooseModel: model;
										sourceAnchor: (self sourceAnchorFor: each);
										propertyNamed: #ast put: each;
										yourself) ] ] ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> importClassParts [
	self
		javaAstsDo: [ :node | 
			node
				withAllNodesDo: [ :each | 
					[ ((each isKindOf: JavaMethodDeclarationNode)
						or: [ each isKindOf: JavaAbstractMethodDeclarationNode ])
						ifTrue: [ self ensureMethodFrom: each ].
					(each isKindOf: JavaLambdaExpressionNode)
						ifTrue: [ self ensureLambdaFrom: each ].
					(each isKindOf: JavaInitializerNode)
						ifTrue: [ self ensureInitializerFrom: each ].
					(each isKindOf: JavaConstructorDeclarationNode)
						ifTrue: [ self ensureConstructorFrom: each ].
					(each isKindOf: JavaFieldDeclarationNode)
						ifTrue: [ self ensureFieldFrom: each ].
					(each isKindOf: JavaNewClassNode)
						ifTrue: [ self ensureInnerClassFrom: each ].
					(each isKindOf: JavaLocalVariableDeclarationNode)
						ifTrue: [ self ensureLocalVariables: each ].
					(each isKindOf: JavaForEachStatementNode)
						ifTrue: [ self ensureForEachLocalVariable: each ].
					(each isKindOf: JavaTryStatementNode)
						ifTrue: [ self ensureTryVariables: each ].
					(each isKindOf: JavaCatchClauseNode)
						ifTrue: [ self ensureCatchVariables: each ].
					(each isKindOf: JavaInstanceofPatternExpressionNode)
						ifTrue: [ self ensureInstanceofPatternVariable: each ].
					(each isKindOf: JavaRecordDeclarationNode)
						ifTrue: [ each parameters do: [ :parm | self ensureRecordMethodAndVariableFrom: parm ] ] ]
						on: Error
						do: [ :ex | ex return ] ] ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> importClasses [
	self
		javaAstsDo: [ :node | 
			node
				withAllNodesOfType: JavaClassDeclarationNode
				do: [ :each | self createClassOrInterfaceFrom: each ] ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> importEnums [
	self
		javaAstsDo: [ :node | 
			node
				withAllNodesOfType: JavaEnumDeclarationNode
				do: [ :each | self createEnumFrom: each ] ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> importFiles [
	folders := Dictionary new.
	self
		javaAstsDo: [ :node | 
			node
				attributeNamed: #famixFile
				put: (self ensureFileFrom: node filename asFileReference) ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> importInterfaces [
	self
		javaAstsDo: [ :node | 
			node
				withAllNodesDo: [ :each | 
					(each isKindOf: JavaInterfaceDeclarationNode)
						ifTrue: [ (self createClassOrInterfaceFrom: each) isInterface: true ].
					(each isKindOf: JavaAnnotationInterfaceNode)
						ifTrue: [ self createAnnotationTypeFrom: each ] ] ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> importMethodSource [
	| visitor |
	visitor := GtJavaMethodVisitor new importer: self.
	self javaAstsDo: [ :node | visitor acceptNode: node ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> importNamespaces [
	self
		javaAstsDo: [ :each | 
			each packageDeclaration
				ifNotNil: [ :decl | each attributeNamed: #container put: (self ensureNamespaceFrom: decl name) ] ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> importRecords [
	self
		javaAstsDo: [ :node | 
			node
				withAllNodesOfType: JavaRecordDeclarationNode
				do: [ :each | self createClassOrInterfaceFrom: each ] ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> javaAstsDo: aBlock [
	asts
		ifNil: [ asts := (JavaParser sourceFilesIn: baseDirectory)
					collect: [ :each | JavaParser parseFileWithErrors: each ] ].
	asts do: aBlock
]

{ #category : #accessing }
GtSmaCCJavaImporter >> localsFor: aNode [
	^ (aNode
		parentOfType: {JavaBlockNode.
				JavaMethodDeclarationNode.
				JavaLambdaExpressionNode.
				JavaConstructorDeclarationNode.
				JavaInitializerNode})
		attributeNamed: #locals
		ifAbsentPut: [ Dictionary new ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> lookupAnnotatedType: aNode [
	| prev |
	prev := typeClass.
	typeClass := FAMIXAnnotationType.
	^ [ self lookupType: aNode ] ensure: [ typeClass := prev ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> lookupContainer: aNode in: fromNode [
	| name |
	name := aNode name source.
	(aNode class = JavaNameNode or: [ aNode class = JavaTypeNameNode ])
		ifTrue: [ ^ name first isUppercase
				ifTrue: [ self lookupTypeNamed: name in: fromNode ]
				ifFalse: [ self ensureRootNamespace: name ] ].
	(name first isUppercase
		and: [ (aNode isKindOf: JavaQualifiedNameNode)
				or: [ aNode isKindOf: JavaQualifiedTypeNameNode ] ])
		ifTrue: [ ^ self ensureType: aNode ].
	^ self
		ensureNamespace: name
		in: (self lookupContainer: aNode nspace in: fromNode)
]

{ #category : #accessing }
GtSmaCCJavaImporter >> lookupOnDemandTypeNamed: aString in: aNode [
	(aNode attributeNamed: #container)
		ifNotNil: [ :container | 
			container children
				detect: [ :each | each name = aString and: [ each isKindOf: FAMIXType ] ]
				ifFound: [ :each | ^ each ] ].
	^ aNode parent
		ifNil: [ | unknown |
			aNode imports
				do: [ :each | 
					((each isKindOf: JavaTypeImportOnDemandDeclarationNode)
						and: [ each staticToken isNil ])
						ifTrue: [ | ns |
							ns := self ensureNamespaceFrom: each name.
							ns children
								detect: [ :type | type name = aString and: [ type isKindOf: FAMIXType ] ]
								ifFound: [ :type | ^ type ].
							((specificImports at: each name ifAbsent: [ #() ]) includes: aString)
								ifTrue: [ ^ self createUnknownType: aString in: ns ] ] ].
			javaLang children
				detect: [ :each | each name = aString and: [ each isKindOf: FAMIXType ] ]
				ifFound: [ :each | ^ each ].
			unknown := self ensureRootNamespace: '__UNKNOWN__'.
			unknown children
				detect: [ :type | type name = aString and: [ type isKindOf: FAMIXType ] ]
				ifNone: [ self createUnknownType: aString in: unknown ] ]
		ifNotNil: [ self lookupOnDemandTypeNamed: aString in: aNode parent ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> lookupType: aNode [
	^ [ (aNode class = JavaTypeNameNode or: [ aNode class = JavaNameNode ])
		ifTrue: [ self lookupTypeNamed: aNode name source in: aNode ]
		ifFalse: [ self
				lookupTypeNamed: aNode name source
				inContainer: (self lookupContainer: aNode nspace in: aNode) ] ]
		on: Error
		do: [ :ex | ex return: nil ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> lookupTypeNamed: aString in: aNode [
	aNode topParent imports
		do: [ :each | 
			each class = JavaSingleTypeImportDeclarationNode
				ifTrue: [ each name name source = aString ifTrue: [ ^ self ensureType: each name ] ] ].
	^ self lookupOnDemandTypeNamed: aString in: aNode
]

{ #category : #accessing }
GtSmaCCJavaImporter >> lookupTypeNamed: name inContainer: ns [
	^ ns children
		detect: [ :each | each name = name and: [ each isKindOf: FAMIXType ] ]
		ifNone: [ self createUnknownType: name in: ns ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> methodNodeFor: aNode [
	^ aNode
		parentOfType: {JavaMethodDeclarationNode.
				JavaLambdaExpressionNode.
				JavaConstructorDeclarationNode.
				JavaInitializerNode}
]

{ #category : #accessing }
GtSmaCCJavaImporter >> model [
	^ model
]

{ #category : #accessing }
GtSmaCCJavaImporter >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtSmaCCJavaImporter >> primitiveTypeNamed: aString [
	^ (primitiveTypes ifNil: [ primitiveTypes := Dictionary new ])
		at: aString
		ifAbsentPut: [ FAMIXPrimitiveType new
				name: aString;
				mooseModel: model;
				yourself ]
]

{ #category : #accessing }
GtSmaCCJavaImporter >> sourceAnchorFor: aNode [
	^ FAMIXIndexedFileEntityAnchor
		file: (aNode topParent attributeNamed: #famixFile)
		startPos: aNode startPosition
		endPos: aNode stopPosition
		model: model
]

{ #category : #accessing }
GtSmaCCJavaImporter >> typeFrom: aNode [
	((aNode isKindOf: JavaPrimitiveTypeNode)
		or: [ aNode isKindOf: JavaVoidTypeNode ])
		ifTrue: [ ^ self
				primitiveTypeNamed: ((aNode class name asString allButFirst: 4) allButLast: 8) asLowercase ].
	(aNode isKindOf: JavaArrayTypeNode) ifTrue: [ ^ self typeFrom: aNode baseType ].
	^ self
		lookupType: ((aNode isKindOf: JavaTypeNameNode) ifTrue: [ aNode ] ifFalse: [ aNode name ])
]
