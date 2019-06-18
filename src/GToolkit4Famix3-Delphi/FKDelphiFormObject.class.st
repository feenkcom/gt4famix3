Class {
	#name : #FKDelphiFormObject,
	#superclass : #FKDelphiFormEntity,
	#instVars : [
		'targetEntity',
		'objectProperties',
		'objects',
		'parentObject'
	],
	#category : #'GToolkit4Famix3-Delphi-Importer'
}

{ #category : #testing }
FKDelphiFormObject >> hasSqlDeleteProperty [
	^ (self objectPropertyNamed: 'sqldelete.strings') notNil
]

{ #category : #testing }
FKDelphiFormObject >> hasSqlInsertProperty [
	^ (self objectPropertyNamed: 'sqlinsert.strings') notNil
]

{ #category : #testing }
FKDelphiFormObject >> hasSqlProperty [
	^ (self objectPropertyNamed: 'sql.strings') notNil
]

{ #category : #testing }
FKDelphiFormObject >> hasSqlUpdateProperty [
	^ (self objectPropertyNamed: 'sqlupdate.strings') notNil
]

{ #category : #accessing }
FKDelphiFormObject >> icon [
	| iconName |
	iconName := (self targetEntity declaredType name asLowercase) asSymbol.
	^ (FKDelphiIcons class canUnderstand: iconName) 
		ifTrue: [ FKDelphiIcons perform: iconName ]
		ifFalse: [ (Form extent: 32@32) fillGray ]
]

{ #category : #initialize }
FKDelphiFormObject >> initialize [
	super initialize.
	objectProperties := FMNullMultivalueLink on: self opposite: #parentObject: selector: #objectProperties.
	objects := FMNullMultivalueLink on: self opposite: #parentObject: selector: #objects
]

{ #category : #testing }
FKDelphiFormObject >> isRoot [
	^ self parentObject isNil
]

{ #category : #testing }
FKDelphiFormObject >> isTOraQuery [
	^ self targetEntity notNil and: [ self targetEntity isTOraQuery ]
]

{ #category : #testing }
FKDelphiFormObject >> isTOraSQL [
	^ self targetEntity notNil and: [ self targetEntity isTOraSQL ]
]

{ #category : #testing }
FKDelphiFormObject >> isTOraStoredProc [
	^ self targetEntity notNil and: [ self targetEntity isTOraStoredProc ]
]

{ #category : #accessing }
FKDelphiFormObject >> leftPropertyValue [
	^ self objectPropertyNamed: 'left' 
		ifPresent: [ :property | property propertyValue asInteger ] 
		ifAbsent: [0]
]

{ #category : #printing }
FKDelphiFormObject >> mooseNameOn: aStream [
	self targetEntity 
		ifNotNil: [:attr | attr mooseNameOn: aStream]
		ifNil: [ super mooseNameOn: aStream ]
]

{ #category : #accessing }
FKDelphiFormObject >> objectProperties [
	<MSEProperty: #objectProperties type: #FKDelphiFormObjectProperty" opposite: #parentObject"> <multivalued> <derived>
	^ objectProperties
]

{ #category : #accessing }
FKDelphiFormObject >> objectProperties: aCollection [
	objectProperties value: aCollection
]

{ #category : #accessing }
FKDelphiFormObject >> objectPropertyNamed: aString [
	^ self objectPropertyNamed: aString ifAbsent: [ nil ]
]

{ #category : #accessing }
FKDelphiFormObject >> objectPropertyNamed: aString ifAbsent: aBlock [
	^ self objectProperties 
		detect: [ :each | each name asLowercase = aString asLowercase ]
		ifNone: aBlock 
]

{ #category : #accessing }
FKDelphiFormObject >> objectPropertyNamed: aString ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ self objectProperties 
		detect: [ :each | each name asLowercase = aString asLowercase ]
		ifFound: [ :property | aPresentBlock value: property ]
		ifNone: anAbsentBlock
]

{ #category : #accessing }
FKDelphiFormObject >> objects [
	^ objects
]

{ #category : #accessing }
FKDelphiFormObject >> objects: anObject [
	objects value: anObject
]

{ #category : #accessing }
FKDelphiFormObject >> parentObject [
	<MSEProperty: #parentObject type: #FKDelphiFormObject" opposite: #objectProperties">
	^ parentObject
]

{ #category : #accessing }
FKDelphiFormObject >> parentObject: aDelphiFormObject [
	parentObject := FMMultivalueLink 
		on: self
		update: #objects
		from: self parentObject
		to: aDelphiFormObject
]

{ #category : #accessing }
FKDelphiFormObject >> sqlDeletePropertyValue [
	^ (self objectPropertyNamed: 'sqldelete.strings') propertyValue
]

{ #category : #accessing }
FKDelphiFormObject >> sqlInsertPropertyValue [
	^ (self objectPropertyNamed: 'sqlinsert.strings') propertyValue
]

{ #category : #accessing }
FKDelphiFormObject >> sqlLockPropertyValue [
	^ (self objectPropertyNamed: 'sqllock.strings') propertyValue
]

{ #category : #accessing }
FKDelphiFormObject >> sqlPropertyValue [
	^ (self objectPropertyNamed: 'sql.strings') propertyValue
]

{ #category : #enumerating }
FKDelphiFormObject >> sqlStringsDo: aBlock [
	self hasSqlProperty ifTrue: [ aBlock value: self sqlPropertyValue ].
	self hasSqlInsertProperty ifTrue: [ aBlock value: self sqlInsertPropertyValue ].
	self hasSqlUpdateProperty ifTrue: [ aBlock value: self sqlUpdatePropertyValue ].
	self hasSqlDeleteProperty ifTrue: [ aBlock value: self sqlDeletePropertyValue ].
]

{ #category : #accessing }
FKDelphiFormObject >> sqlUpdatePropertyValue [
	^ (self objectPropertyNamed: 'sqlupdate.strings') propertyValue
]

{ #category : #accessing }
FKDelphiFormObject >> storedProcNamePropertyValue [
	^ (self objectPropertyNamed: 'StoredProcName') propertyValue
]

{ #category : #accessing }
FKDelphiFormObject >> targetEntity [
	<MSEProperty: #targetEntity type: #FAMIXContainerEntity" opposite: #delphiFormObjects"> 
	<MSEComment: 'The entity that the object instantiates. It can be a class or an attribute'>
	^ targetEntity
]

{ #category : #accessing }
FKDelphiFormObject >> targetEntity: anEntity [
	targetEntity := FMMultivalueLink 
		on: self
		update: #delphiFormObjects
		from: self targetEntity
		to: anEntity
]

{ #category : #accessing }
FKDelphiFormObject >> topPropertyValue [
	^ self 
		objectPropertyNamed: 'top' 
		ifPresent: [ :property | property propertyValue asInteger ] 
		ifAbsent: [0]
]
