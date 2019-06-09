Extension { #name : #DelphiProgramNode }

{ #category : #'*GToolkit4Famix3-Delphi' }
DelphiProgramNode >> statementsMatching: aStringQuery [
	| nodes |
	nodes := OrderedCollection new.
	self statementsMatching: aStringQuery do: [ :each :mapping | nodes add: each ].
	^ nodes
]

{ #category : #'*GToolkit4Famix3-Delphi' }
DelphiProgramNode >> statementsMatching: aStringQuery do: aBlockWithTwoArguments [
	"aBlockWithTwoArguments evaluates for the node and for the mapping dictionary"
	| pattern mapping |
	pattern := DelphiParser parse: aStringQuery startingAt: DelphiParser startingStateForStatement.
	self allNodesDo: [:each |
		mapping := Dictionary new.
		(pattern match: each inContext: mapping)
			ifTrue: [ aBlockWithTwoArguments value: each value: mapping ] ]
]
