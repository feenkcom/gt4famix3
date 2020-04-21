Extension { #name : #MooseGroup }

{ #category : #'*GToolkit4Famix3-JavaScript' }
MooseGroup >> includedComponentsAndTemplates [
	^ self flatCollectAsSet: [ :each | each includedComponentsAndTemplates ]
]
