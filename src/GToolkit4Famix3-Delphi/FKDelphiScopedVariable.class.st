Class {
	#name : #FKDelphiScopedVariable,
	#superclass : #FAMIXStructuralEntity,
	#instVars : [
		'parentScope'
	],
	#category : #'GToolkit4Famix3-Delphi-Importer'
}

{ #category : #meta }
FKDelphiScopedVariable class >> annotation [
	<MSEClass: #ScopedVariable super: #FAMIXStructuralEntity>
	<package: #Delphi>

	^ self
]

{ #category : #printing }
FKDelphiScopedVariable >> mooseNameOn: stream [
	self parentScope mooseNameOn: stream.
	stream 
		nextPutAll: '::';
		nextPutAll: self name
]

{ #category : #'moosechef-scoping-filtering' }
FKDelphiScopedVariable >> namespaceScope [
	^ self parentScope namespaceScope
]

{ #category : #accessing }
FKDelphiScopedVariable >> parentScope [
	<MSEProperty: #parentScope type: #FKDelphiScopingEntity opposite: #scopedVariables>
	^ parentScope
]

{ #category : #accessing }
FKDelphiScopedVariable >> parentScope: aDelphiScopingEntity [
	parentScope := FMMultivalueLink on: self
					update: #scopedVariables 
					from: self parentScope
					to: aDelphiScopingEntity
]
