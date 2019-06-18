Class {
	#name : #FKDelphiFormEntity,
	#superclass : #FAMIXSourcedEntity,
	#category : #'GToolkit4Famix3-Delphi-Importer'
}

{ #category : #accessing }
FKDelphiFormEntity >> parentObject [
	^ self subclassResponsibility
]

{ #category : #accessing }
FKDelphiFormEntity >> topParentObject [
	^ self parentObject 
		ifNil: [ self ] 
		ifNotNil: [ self parentObject topParentObject ]
]
