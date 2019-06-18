Class {
	#name : #FKDelphiFormObjectGroup,
	#superclass : #MooseGroup,
	#category : #'GToolkit4Famix3-Delphi-Importer'
}

{ #category : #'as yet unclassified' }
FKDelphiFormObjectGroup >> mooseFinderNestingIn: composite [
	<moosePresentationOrder: 40>
	composite roassal2
		title: 'Nesting';
		initializeView: [ RTMondrian new ];
		painting: [ :view | 
			view shape circle size: 50; color: (Color gray alpha: 0.5).
			view nodes: self.
			view shape line width: 2; color: (Color gray alpha: 0.5).
			view edges connectFrom: #parentObject.
			view layout cluster.
			view view pushBackEdges ]
]

{ #category : #'as yet unclassified' }
FKDelphiFormObjectGroup >> viewNestingOn: view [
	view shape circle size: 20; color: (Color gray alpha: 0.5).
	view nodes: self.
	view shape line width: 2; color: (Color gray alpha: 0.5).
	view edges connectFrom: #parentObject.
	view layout cluster.
	view view pushBackEdges.
]
