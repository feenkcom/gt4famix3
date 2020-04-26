Class {
	#name : #GtAngularModuleGroup,
	#superclass : #MooseGroup,
	#category : #'GToolkit4Famix3-JavaScript-Importer'
}

{ #category : #'as yet unclassified' }
GtAngularModuleGroup class >> annotation [
	<MSEClass: #AngularModuleGroup super: #MooseGroup>
	
]

{ #category : #'as yet unclassified' }
GtAngularModuleGroup >> viewRootDependenciesOn: view [
	| dependencies |
	dependencies := Dictionary new.
	(self reject: #isStub) do: [ :module | 
		(dependencies at: module rootName ifAbsentPut: [ Set new ])
			addAll: (module dependencies collect: #rootName)  ].
	dependencies.

	view shape label color: Color black.
	view nodes: (dependencies keys "reject: [:each | each = 'mobi.ui']").
	view shape horizontalBezierLine color: (Color lightGray alpha: 0.5).
	view edges 
		source: dependencies associations 
		connectFrom: #key
		toAll: [:each | each value reject: [ :d | each key = d ] ].
	view layout horizontalDominanceTree layered.
	view view pushBackEdges
]
