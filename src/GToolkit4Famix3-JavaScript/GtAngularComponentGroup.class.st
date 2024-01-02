Class {
	#name : #GtAngularComponentGroup,
	#superclass : #MooseGroup,
	#category : #'GToolkit4Famix3-JavaScript-Importer'
}

{ #category : #'instance creation' }
GtAngularComponentGroup class >> annotation [
	<MSEClass: #AngularComponentGroup super: #MooseGroup>
	
]

{ #category : #'as yet unclassified' }
GtAngularComponentGroup >> viewInclusionFromMcsAndVvnOn: view [
	view shape rectangle 
		color: Color black;
		borderWidth: 2;
		if: [ :each | (each deepCollect: #includingComponentsAndTemplates) anySatisfy: [ :included | included isMobiMcs ] ]
		color: Color red;
		if: [ :each | (each deepCollect: #includingComponentsAndTemplates) anySatisfy: [ :included | included isMobiVvn ] ]
		borderColor: Color blue	.
	view nodes: self.
	view edges connectFromAll: [:each | each deepCollect: #includingComponentsAndTemplates].
	view layout dominanceTree.
	view view pushBackEdges
]
