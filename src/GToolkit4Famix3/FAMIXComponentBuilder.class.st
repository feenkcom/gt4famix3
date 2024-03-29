Class {
	#name : #FAMIXComponentBuilder,
	#superclass : #Object,
	#instVars : [
		'components',
		'entitiesToComponents',
		'dependencies'
	],
	#category : 'GToolkit4Famix3'
}

{ #category : #building }
FAMIXComponentBuilder >> component: aString with: aCollection [
	| component |
	component := FAMIXComponent new name: aString; entities: aCollection.
	self components add: component.
	aCollection do: [ :anEntity |
		self entitiesToComponents 
			at: anEntity 
			put: component ].
	^ component
]

{ #category : #accessing }
FAMIXComponentBuilder >> components [
	^ components
]

{ #category : #accessing }
FAMIXComponentBuilder >> components: anObject [
	components := anObject
]

{ #category : #building }
FAMIXComponentBuilder >> connect: aCollection from: aFromBlock to: aToBlock [
	aCollection do: [ :aDependency |
		entitiesToComponents 
			at: (aFromBlock value: aDependency)
			ifPresent: [ :aSourceComponent | 
				entitiesToComponents 
					at: (aToBlock value: aDependency)
					ifPresent: [ :aTargetComponent |
						self 
							ensureDependencyFrom: aSourceComponent 
							to: aTargetComponent 
							for: aDependency ] ] ]
]

{ #category : #building }
FAMIXComponentBuilder >> connect: aCollection from: aFromBlock toAll: aToAllBlock [
	aCollection do: [ :aDependency |
		entitiesToComponents 
			at: (aFromBlock value: aDependency)
			ifPresent: [ :aSourceComponent | 
				(aToAllBlock value: aDependency) do: [ :aTargetEntity |
					entitiesToComponents 
						at: aTargetEntity
						ifPresent: [ :aTargetComponent |
							dependencies add: (FAMIXComponentDependency new
								source: aSourceComponent;
								target: aTargetComponent) ] ] ] ]
]

{ #category : #accessing }
FAMIXComponentBuilder >> dependencies [
	^ dependencies
]

{ #category : #building }
FAMIXComponentBuilder >> ensureDependencyFrom: aSourceComponent to: aTargetComponent for: aDependency [
	aSourceComponent outgoingDependencies 
		detect: [ :aComponentDependency | aComponentDependency target = aTargetComponent ]
		ifFound: [ :aComponentDependency | aComponentDependency addEntityDependency: aDependency ]
		ifNone: [ dependencies add: (FAMIXComponentDependency new source: aSourceComponent; target: aTargetComponent; addEntityDependency: aDependency) ]
]

{ #category : #accessing }
FAMIXComponentBuilder >> entitiesToComponents [
	^ entitiesToComponents
]

{ #category : #accessing }
FAMIXComponentBuilder >> entitiesToComponents: anObject [
	entitiesToComponents := anObject
]

{ #category : #accessing }
FAMIXComponentBuilder >> gtComponentsFor: aView [
	<gtView>
	^ aView list
		title: 'Components';
		items: [ self components ]
]

{ #category : #accessing }
FAMIXComponentBuilder >> gtDependenciesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Dependencies';
		items: [ self dependencies ];
		column: 'From' text: [:d | d source gtDisplayString];
		column: 'To' text: [:d | d target gtDisplayString];
		column: 'Amount' text: [:d | d entityDependencies size] width: 100
]

{ #category : #accessing }
FAMIXComponentBuilder >> gtMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Map';
		painting: [ :m | self paintMapWith: m ]
]

{ #category : #initialize }
FAMIXComponentBuilder >> initialize [
	super initialize.
	entitiesToComponents := IdentityDictionary new.
	components := OrderedCollection new.
	dependencies := OrderedCollection new
]

{ #category : #accessing }
FAMIXComponentBuilder >> paintMapWith: m [
	m nodes 
		stencil: [ :c | BlTextElement new text: c name asRopedText glamorousRegularFont];
		with: components.
	m edges 
		fromNearestCircle;
		toNearestCircle;
		stencil: [:d | 
			BlParabollaArcElement new
			when: BlClickEvent do: [:e | e target phlow spawnObject: d];
			zIndex: -1;
				curvatureFraction: 0.2;
				border: (BlBorder paint: (Color gray alpha: 0.2) width: ((d entityDependencies size // 20) max: 1));
				toHead: (BlArrowheadSimpleArrow new
					border: (BlBorder builder paint: (Color gray alpha: 0.2); width: 2; build))];
		connect: dependencies from: #source to: #target.
	m layout circle
]
