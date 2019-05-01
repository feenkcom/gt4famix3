Extension { #name : #MooseAbstractGroup }

{ #category : #'*GToolkit4Famix3' }
MooseAbstractGroup >> gtDisplayOn: aStream [ 
	super gtDisplayOn: aStream.
	aStream nextPut: $(. 
	aStream nextPutAll: self size printString. 
	aStream nextPut: $)
]

{ #category : #'*GToolkit4Famix3' }
MooseAbstractGroup >> gtItemsFor: aView [
	<gtView>
	^ aView list
		priority: 1;
		items: [self entities sorted: [ :a :b | a gtDisplayString < b gtDisplayString ]];
"		send:
				[ :each | 
			each isNil
				ifTrue: [ nil ]
				ifFalse: [ each size = 1
						ifTrue: [ each first ]
						ifFalse: [ each asMooseGroup ] ] ];"
		itemFormat: #gtDisplayString;
		"icon: #mooseIcon;"
		title: 'Items'
]

{ #category : #'*GToolkit4Famix3' }
MooseAbstractGroup >> gtNavigationItems [
	| entity assocs pragmaValueAssociations navigationPragmas |
	
	"returns associations in form name->object for navigation entities obtained from
	the pragma #navigation:"
	
	navigationPragmas := (Pragma
		allNamed: #navigation:
		from: self class
		to: MooseEntity)
		sorted: [ :a :b | (a argumentAt: 1) < (b argumentAt: 1) ].
	pragmaValueAssociations := navigationPragmas
		collect: [ :pragma | 
			(pragma argumentAt: 1) -> ([self perform: pragma methodSelector] ifError: [nil]) ].
					
	"filter out nils and empty collections, sort"
	assocs := (pragmaValueAssociations
		reject: [ :association | 
			association value isNil
				or: [ association value isCollection and: [ association value isEmpty ] ] ])
		sorted: [ :a :b | 
			a key asLowercase asString
				< b key asLowercase asString ].
	^ super gtNavigationItems, assocs
]
