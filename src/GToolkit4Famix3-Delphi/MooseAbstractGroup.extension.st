Extension { #name : #MooseAbstractGroup }

{ #category : #'*GToolkit4Famix3-Delphi' }
MooseAbstractGroup >> allDelphiPrograms [
	<navigation: 'All Delphi programs'>
	^ self allWithType: FKDelphiProgram
]

{ #category : #'*GToolkit4Famix3-Delphi' }
MooseAbstractGroup >> allDelphiUnits [
	<navigation: 'All Delphi units'>
	^ self allWithType: FKDelphiUnit
]
