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
MooseEntity >> gtIconName [
	^ #mooseMetamodelEntity
]

{ #category : #'*GToolkit4Famix3' }
MooseEntity >> gtNavigationFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Navigation';
		priority: 1;
		items: [ self gtNavigationItems ];
		column: 'Icon' iconName: [ :assoc | assoc value gtIconName ] width: 36;
		column: 'Name'
			text: [ :assoc | 
				' '
					join: ((assoc key argumentAt: 1) piecesCutWhereCamelCase collect: #capitalized) ];
		column: 'Value' text: [ :assoc | assoc value gtDisplayString ];
		send: [ :assoc | assoc value ];
		contextItemLabel: 'Browse the method implementing the navigation'
			action: [ :element :assoc | 
				element phlow
					spawnTool: (GtMethodCoderTool
							compiledMethod: assoc key methodClass >> assoc key methodSelector) ];
		contextItemLabel: 'Copy method name'
			action: [ :anElement :assoc | Clipboard clipboardText: assoc key methodSelector ]
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
		pragma -> value ].
	^ (pragmaValueAssociations
		reject: [ :association | 
			association value isNil or: [ 
				association value isCollection and: [ 
					association value isEmpty ] ] ])
		sorted: [ :a :b | (a key argumentAt: 1) < (b key argumentAt: 1) ]
]

{ #category : #'*GToolkit4Famix3' }
MooseEntity class >> gtNavigationMethodsFor: aView [
	<gtClassView>
	<gtView>
	^ aView columnedList
		title: 'Moose navigation';
		items: [ (Pragma
				allNamed: #navigation:
				from: self instanceSide
				to: MooseEntity) sort: [ :a :b | (a argumentAt: 1) < (b argumentAt: 1) ] ];
		column: 'Name' text: [ :aPragma | aPragma argumentAt: 1 ];
		column: 'Method' text: [ :aPragma | aPragma methodSelector ];
		sendTool: [ :aPragma | GtMethodCoderTool compiledMethod: aPragma method ];
		contextItemLabel: 'Copy method name'
			action: [ :anElement :aPragma | Clipboard clipboardText: aPragma methodSelector ]
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
		column: 'Properties' text: [ :each | each name ];
		column: 'Value'
			text: [ :each | 
			[ (self mmGetProperty: each) asString ]
				on: Error
				do: [ :e | e printString ] ]
]

{ #category : #'*GToolkit4Famix3' }
MooseEntity >> spotterProcessorsFor: aSpotterStep [
	super spotterProcessorsFor: aSpotterStep.
	"self mooseSpecificSpotterProcessorsFor: aSpotterStep"
]
