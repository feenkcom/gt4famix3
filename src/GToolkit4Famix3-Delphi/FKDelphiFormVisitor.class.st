Class {
	#name : #FKDelphiFormVisitor,
	#superclass : #DelphiFormParseNodeVisitor,
	#instVars : [
		'importer',
		'stack',
		'unit',
		'fileName'
	],
	#category : #'GToolkit4Famix3-Delphi-Importer'
}

{ #category : #accessing }
FKDelphiFormVisitor >> fileName [
	^ fileName
]

{ #category : #accessing }
FKDelphiFormVisitor >> fileName: anObject [
	fileName := anObject
]

{ #category : #accessing }
FKDelphiFormVisitor >> importer [
	^ importer
]

{ #category : #accessing }
FKDelphiFormVisitor >> importer: anObject [
	importer := anObject
]

{ #category : #initialize }
FKDelphiFormVisitor >> initialize [
	stack := Stack new
]

{ #category : #private }
FKDelphiFormVisitor >> push: anEntity andDo: aBlock [
	stack push: anEntity.
	aBlock value.
	stack pop
]

{ #category : #accessing }
FKDelphiFormVisitor >> stack [
	^ stack
]

{ #category : #accessing }
FKDelphiFormVisitor >> unit: anObject [
	unit := anObject.
]

{ #category : #visiting }
FKDelphiFormVisitor >> visitObject: aNode [
	| famixObject |
	famixObject := FKDelphiFormObject new.
	famixObject fkDelphiAST: aNode.
	importer targetModel add: famixObject.
	importer
		createSourceAnchorFor: famixObject
		fileName: fileName
		start: aNode startPosition
		end: aNode stopPosition.
	stack isEmpty
		ifTrue: [ 
			"This means we are dealing with the top object and only for this one we can know the scoped variable at this stage in importing.
			The rest are being resolved later by the importer. We need to store the root information because we use that later to resolve the nested objects"
			| famixVariable |
			famixVariable := importer
				ensureUnitVariable: aNode nameToken value
				inUnit: unit.
			famixVariable declaredType ifNil: [ famixVariable declaredType: importer unknownType ].
			famixObject targetEntity: famixVariable ]
		ifFalse: [ 
			"if the stack is not empty, we link the objects"
			famixObject parentObject: stack top ].
	self push: famixObject andDo: [ super visitObject: aNode ]
]

{ #category : #visiting }
FKDelphiFormVisitor >> visitProperty: aNode [
	| famixProperty propertyName |
	propertyName := '.' join: (aNode name names collect: #value).
	famixProperty := FKDelphiFormObjectProperty new.
	famixProperty name: propertyName.
	famixProperty parentObject: stack top.
	famixProperty propertyValue: aNode value delphiToPharoValue
]
