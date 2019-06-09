Class {
	#name : #FKDelphiImporter,
	#superclass : #Object,
	#instVars : [
		'targetModel',
		'units',
		'namespaces',
		'methods',
		'types',
		'functions',
		'attributes',
		'programs'
	],
	#category : #'GToolkit4Famix3-Delphi-Importer'
}

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

{ #category : #ensuring }
FKDelphiImporter >> createUnitNamed: aString [
	^ FKDelphiUnit new name: aString; isStub: true
]

{ #category : #creating }
FKDelphiImporter >> createUsesAssociationFrom: aUnit withSignature: aString [
	| usesAssociation |
	usesAssociation := FKDelphiUnitUsesAssociation new.
	usesAssociation signature: aString.
	usesAssociation userUnit: aUnit.
	targetModel add: usesAssociation.
	^ usesAssociation
]

{ #category : #ensuring }
FKDelphiImporter >> ensureAttributeNamed: aString inType: aFamixType [
	^ self 
		in: attributes 
		at: (aFamixType mooseName, '::', aString)
		ifAbsentPut: [ FAMIXAttribute new name: aString; parentType: aFamixType ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureFunctionNamed: aString inUnit: aFamixUnit [
	^ self 
		in: functions 
		at: (aFamixUnit mooseName, '::', aString)
		ifAbsentPut: [ FAMIXFunction new name: aString; container: aFamixUnit ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureMethodNamed: aString inType: aFamixType [
	^ self 
		in: methods 
		at: (aFamixType mooseName, '::', aString)
		ifAbsentPut: [ FAMIXMethod new name: aString; parentType: aFamixType ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureNamespaceNamed: aString inNamespace: aFamixNamespace [
	| qualifiedName |
	qualifiedName := aFamixNamespace
		ifNil: [ aString ]
		ifNotNil: [ aFamixNamespace mooseName, '::', aString ].
	^ self 
		in: namespaces
		at: qualifiedName
		ifAbsentPut: [ FAMIXNamespace new name: aString; parentScope: aFamixNamespace ]
]

{ #category : #ensuring }
FKDelphiImporter >> ensureProgramNamed: aString inNamespace: aFamixNamespace [
	| qualifiedName |
	qualifiedName := aFamixNamespace
		ifNil: [ aString ]
		ifNotNil: [ aFamixNamespace mooseName, '::', aString ].
	^ self 
		in: programs 
		at: qualifiedName
		ifAbsentPut: [ FKDelphiProgram new name: aString; parentScope: aFamixNamespace ]
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
		ifNotNil: [ aFamixNamespace mooseName, '::', aString ].
	^ self 
		in: units 
		at: qualifiedName
		ifAbsentPut: [ (self createUnitNamed: aString) parentScope: aFamixNamespace ]
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
			[ 
				(each extension = 'pas' or: [ each extension = 'dpr' ]) 
					ifTrue: [ self importPasOrDprFile: each relativeTo: aDirectory ].
			] on: Error do: [ :error | (each -> error) asBeaconSignal emit ] ]
		displayingProgress: 'Importing .pas files'.
	targetModel rootFolder: aDirectory.
	self resolveAssociations.
	self populateModel
]

{ #category : #importing }
FKDelphiImporter >> importPasOrDprFile: aFile relativeTo: aDirectory [
	| contents ast visitor |
	contents := aFile readStreamDo: [ :s | 
		[ s contents ] on: Error do: [ s converter: Latin1TextConverter new; contents ] ].
	ast := DelphiParser parse: contents.
	visitor := FKDelphiNestingPasVisitor new 
		fileName: ((aFile fullName removePrefix: aDirectory fullName) removePrefix: '/'); 
		importer: self.
	ast acceptVisitor: visitor
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
	types := Dictionary new.
	methods := Dictionary new.
	functions := Dictionary new.
	attributes := Dictionary new.
]

{ #category : #importing }
FKDelphiImporter >> populateModel [
	targetModel 
		addAll: namespaces values;
		addAll: types values;
		addAll: methods values;
		addAll: units values;
		addAll: programs values;
		addAll: functions values;
		addAll: attributes values
]

{ #category : #accessing }
FKDelphiImporter >> programs [
	^ programs
]

{ #category : #accessing }
FKDelphiImporter >> programs: anObject [
	programs := anObject
]

{ #category : #importing }
FKDelphiImporter >> resolveAssociations [
	units do: [ :unit | self resolveAssociationsFor: unit ].
	programs do: [ :program | self resolveAssociationsFor: program ]
]

{ #category : #importing }
FKDelphiImporter >> resolveAssociationsFor: aScopingEntity [
	aScopingEntity outgoingUsesAssociations do: [ :assoc | 
		assoc usedUnit: (self ensureUnitNamed: assoc signature) ]	
]

{ #category : #accessing }
FKDelphiImporter >> targetModel [
	^ targetModel
]

{ #category : #accessing }
FKDelphiImporter >> targetModel: anObject [
	targetModel := anObject
]
