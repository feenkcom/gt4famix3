Extension { #name : #MooseAbstractGroup }

{ #category : #'*GToolkit4Famix3-Delphi' }
MooseAbstractGroup >> allDelphiConstantAttributes [
	<navigation: 'All Delphi constant attributes'>
	^ self allWithType: FKDelphiConstantAttribute
]

{ #category : #'*GToolkit4Famix3-Delphi' }
MooseAbstractGroup >> allDelphiConstants [
	<navigation: 'All Delphi constants'>
	^ self allDelphiUnitConstants, self allDelphiConstantAttributes
]

{ #category : #'*GToolkit4Famix3-Delphi' }
MooseAbstractGroup >> allDelphiFormObjects [
	<navigation: 'All Delphi form objects'>
	^ self allWithType: FKDelphiFormObject
]

{ #category : #'*GToolkit4Famix3-Delphi' }
MooseAbstractGroup >> allDelphiModelUnits [
	<navigation: 'All Delphi model units'>
	^ self allDelphiUnits reject: [ :each | each isStub ]
]

{ #category : #'*GToolkit4Famix3-Delphi' }
MooseAbstractGroup >> allDelphiPrograms [
	<navigation: 'All Delphi programs'>
	^ self allWithType: FKDelphiProgram
]

{ #category : #'*GToolkit4Famix3-Delphi' }
MooseAbstractGroup >> allDelphiRecords [
	<navigation: 'All Delphi record'>
	^ self allWithType: FKDelphiRecord
]

{ #category : #'*GToolkit4Famix3-Delphi' }
MooseAbstractGroup >> allDelphiScopedVariables [
	<navigation: 'All Delphi scoped variables'>
	^ self allDelphiUnitVariables, self allDelphiUnitConstants
]

{ #category : #'*GToolkit4Famix3-Delphi' }
MooseAbstractGroup >> allDelphiUnitConstants [
	<navigation: 'All Delphi unit constants'>
	^ self allWithType: FKDelphiUnitConstant
]

{ #category : #'*GToolkit4Famix3-Delphi' }
MooseAbstractGroup >> allDelphiUnitVariables [
	<navigation: 'All Delphi unit variables'>
	^ self allWithType: FKDelphiUnitVariable
]

{ #category : #'*GToolkit4Famix3-Delphi' }
MooseAbstractGroup >> allDelphiUnits [
	<navigation: 'All Delphi units'>
	^ self allWithType: FKDelphiUnit
]
