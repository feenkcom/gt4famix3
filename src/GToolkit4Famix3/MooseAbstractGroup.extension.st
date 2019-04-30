Extension { #name : #MooseAbstractGroup }

{ #category : #'*GToolkit4Famix3' }
MooseAbstractGroup >> gtItemsFor: aView [
	<gtView>
	^ aView list
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
