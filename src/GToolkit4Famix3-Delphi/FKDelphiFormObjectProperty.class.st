Class {
	#name : #FKDelphiFormObjectProperty,
	#superclass : #FKDelphiFormEntity,
	#instVars : [
		'propertyValue',
		'parentObject',
		'name'
	],
	#category : #'GToolkit4Famix3-Delphi-Importer'
}

{ #category : #initialize }
FKDelphiFormObjectProperty >> initialize [
	super initialize.
	objectProperties := FMNullMultivalueLink on: self opposite: #parentObject: selector: #objectProperties
]

{ #category : #accessing }
FKDelphiFormObjectProperty >> name [
	^ name
]

{ #category : #accessing }
FKDelphiFormObjectProperty >> name: anObject [
	name := anObject
]

{ #category : #accessing }
FKDelphiFormObjectProperty >> parentObject [
	<MSEProperty: #parentObject type: #FKDelphiFormObject opposite: #objectProperties>
	^ parentObject
]

{ #category : #accessing }
FKDelphiFormObjectProperty >> parentObject: aDelphiFormObject [
	parentObject := FMMultivalueLink 
		on: self
		update: #objectProperties
		from: self parentObject
		to: aDelphiFormObject
]

{ #category : #accessing }
FKDelphiFormObjectProperty >> propertyValue [
	^ propertyValue
]

{ #category : #accessing }
FKDelphiFormObjectProperty >> propertyValue: anObject [
	propertyValue := anObject
]
