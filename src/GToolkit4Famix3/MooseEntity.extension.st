Extension { #name : #MooseEntity }

{ #category : #'*GToolkit4Famix3' }
MooseEntity >> complexPropertyPragmas [
	| navProps definedProps |
	self mooseDescription
		ifNil: [ Error
				signal:
					'Moose description are not initialized. Have you refreshed the meta-model? (e.g., MooseModel resetMeta)' ].
	navProps := (Pragma
		allNamed: #navigation:
		from: self class
		to: MooseEntity)
		sorted: [ :a :b | (a argumentAt: 1) < (b argumentAt: 1) ].
	definedProps := (self mooseDescription allAttributes
		reject: [ :a | a type isPrimitive ])
		flatCollect: [ :prop | 
			(prop mmClass implementingClass >> prop implementingSelector) pragmas
				select: [ :each | each selector beginsWith: 'MSEProperty:' ] ].
	^ (OrderedCollection withAll: definedProps)
		addAll: navProps;
		yourself
]

{ #category : #'*GToolkit4Famix3' }
MooseEntity >> gtASTNode [
	^ self propertyNamed: #ast ifAbsent: [  ]
]

{ #category : #'*GToolkit4Famix3' }
MooseEntity >> gtIcon [
	^ MooseIcons mooseMetamodelEntity
]

{ #category : #'*GToolkit4Famix3' }
MooseEntity >> gtNavigationFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Navigation';
		priority: 1;
		items: [ self gtNavigationItems ];
		column: 'Icon' icon: [ :assoc | assoc value gtIcon ];
		column: 'Name' text: [ :assoc | assoc key ];
		column: 'Value' text: [ :assoc | assoc value gtDisplayString ];
		send: [ :assoc | assoc value ]
]

{ #category : #'*GToolkit4Famix3' }
MooseEntity >> gtNavigationItems [
	| pragmaValueAssociations |
	pragmaValueAssociations := self complexPropertyPragmas collect: [ :pragma | 
		| value |
		value := self perform: pragma methodSelector.
		value isCollection ifTrue: [ 
			value size = 1 
				ifTrue: [ value := value anyOne ]
				ifFalse: [ value := value asMooseGroup ] ].
		((' ' join: ((pragma argumentAt: 1) piecesCutWhereCamelCase collect: #capitalized)) ) -> value ].
	^ (pragmaValueAssociations
		reject: [ :association | 
			association value isNil or: [ 
				association value isCollection and: [ 
					association value isEmpty ] ] ])
		sorted: [ :a :b | a key < b key ]
]

{ #category : #'*GToolkit4Famix3' }
MooseEntity >> gtPropertiesFor: aView [
	<gtView>
	(self mooseDescription notNil
		and: [ self mooseDescription allPrimitiveAttributes notEmpty ])
		ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Properties';
		items: [ self mooseDescription allPrimitiveAttributes
				sorted: [ :x :y | x name < y name ] ];
		column: 'Properties' item: [ :each | each name ];
		column: 'Value'
			item: [ :each | 
			[ (self mmGetProperty: each) asString ]
				on: Error
				do: [ :e | e printString ] ]
]

{ #category : #'*GToolkit4Famix3' }
MooseEntity >> mooseSpecificSpotterProcessorsFor: aSpotterStep [
	| entity assocs pragmaValueAssociations |
	entity := self.
	pragmaValueAssociations := entity complexPropertyPragmas
		collect: [ :pragma | 
			pragma -> 	(self perform: pragma methodSelector) ].
	assocs := (pragmaValueAssociations
		reject: [ :association | 
			association value isNil
				or: [ association value isCollection and: [ association value isEmpty ] ] ])
		sorted: [ :a :b | 
			(a key argumentAt: 1) asLowercase asString
				< (b key argumentAt: 1) asLowercase asString ].
	assocs
		do: [ :assoc | 
			aSpotterStep listProcessor
				allCandidates: [ assoc value asMooseGroup ];
				title: (assoc key argumentAt: 1);
				itemIcon: #gtIcon;
				filter: GTFilterSubstring;
				itemName: #gtDisplayString;
				order: 1 ]
]

{ #category : #'*GToolkit4Famix3' }
MooseEntity >> spotterProcessorsFor: aSpotterStep [
	super spotterProcessorsFor: aSpotterStep.
	"self mooseSpecificSpotterProcessorsFor: aSpotterStep"
]
