Extension { #name : #JSProgramNode }

{ #category : #'*GToolkit4Famix3-JavaScript' }
JSProgramNode >> expressionsMatching: aStringQuery [
	| nodes |
	nodes := OrderedCollection new.
	self expressionsMatching: aStringQuery do: [ :each :mapping | nodes add: each ].
	^ nodes
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
JSProgramNode >> expressionsMatching: aStringQuery do: aBlockWithTwoArguments [
	"aBlockWithTwoArguments evaluates for the node and for the mapping dictionary"
	| patterns mapping |
	patterns := JSParser parseAndCacheAll: aStringQuery startingAt: JSParser startingStateForExpression.
	self withAllNodesDo: [:each |
		patterns anySatisfy: [ :pattern | 
			mapping := Dictionary new.
			(pattern match: each inContext: mapping) 
				ifTrue: [ 
					aBlockWithTwoArguments 
						value: each 
						value: (mapping associations collect: [:assoc | assoc key name -> assoc value]) asDictionary.
					true ]
				ifFalse: [ false ] ] ]
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
JSProgramNode >> statementsMatching: aStringQuery [
	| nodes |
	nodes := OrderedCollection new.
	self statementsMatching: aStringQuery do: [ :each :mapping | nodes add: each ].
	^ nodes
]

{ #category : #'*GToolkit4Famix3-JavaScript' }
JSProgramNode >> statementsMatching: aStringQuery do: aBlockWithTwoArguments [
	"aBlockWithTwoArguments evaluates for the node and for the mapping dictionary"
	| pattern mapping |
	pattern := JSParser parse: aStringQuery startingAt: JSParser startingStateForStatement.
	self allNodesDo: [:each |
		mapping := Dictionary new.
		(pattern match: each inContext: mapping)
			ifTrue: [ 
				aBlockWithTwoArguments 
					value: each 
					value: (mapping associations collect: [:assoc | assoc key name -> assoc value]) asDictionary ] ]
]
