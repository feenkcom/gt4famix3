Class {
	#name : #FKDelphiUnit,
	#superclass : #FKDelphiScopingEntity,
	#category : #'GToolkit4Famix3-Delphi-Importer'
}

{ #category : #meta }
FKDelphiUnit class >> annotation [
	<MSEClass: #Unit super: #FKDelphiScopingEntity>
	<package: #Delphi>
	^self
]

{ #category : #accessing }
FKDelphiUnit class >> unknownUnitName [
	^ '__UNKNOWN__'
]

{ #category : #'as yet unclassified' }
FKDelphiUnit >> allDelphiFormObjects [
	^ self mooseModel allDelphiFormObjects select: [ :each | each targetEntity namespaceScope = self ]
]

{ #category : #enumerating }
FKDelphiUnit >> allSourcesDo: aBlock [
	aBlock value: self sourceText.
	self allDelphiFormObjects do: [ :each | 
		each hasSqlProperty ifTrue: [ aBlock value: each sqlPropertyValue ].
		each hasSqlInsertProperty ifTrue: [ aBlock value: each sqlInsertPropertyValue ].
		each hasSqlUpdateProperty ifTrue: [ aBlock value: each sqlUpdatePropertyValue ].
		each hasSqlDeleteProperty ifTrue: [ aBlock value: each sqlDeletePropertyValue ] ]
]

{ #category : #'as yet unclassified' }
FKDelphiUnit >> includesInSource: aStringOrParser [
	self allSourcesDo: [ :source |
		((aStringOrParser asParser sea) parse: source)
			isPetitFailure ifFalse: [ ^ true ] ].
	^ false
]

{ #category : #testing }
FKDelphiUnit >> isDelphiUnit [
	^ true
]

{ #category : #'as yet unclassified' }
FKDelphiUnit >> literals [
	| literals |
	self fkDelphiAST ifNil: [ ^ {  } ].
	literals := Set new.
	self fkDelphiAST allNodesDo: [ :node | 
		node class = DelphiLiteralExpressionNode ifTrue: [ literals add: node value value pharoFromDelphiString ] ].
	^ literals
]

{ #category : #enumerating }
FKDelphiUnit >> sqlStringsDo: aBlock [
	self allDelphiFormObjects do: [:each | each sqlStringsDo: aBlock ]
]

{ #category : #'as yet unclassified' }
FKDelphiUnit >> usedLiterals [
	| literals |
	literals := Set new.
	self fkDelphiAST allNodesDo: [ :node | 
		node class = DelphiLiteralExpressionNode ifTrue: [ literals add: node value value pharoFromDelphiString ] ].
	^ literals
]
