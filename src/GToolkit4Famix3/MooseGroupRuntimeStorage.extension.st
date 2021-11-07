Extension { #name : #MooseGroupRuntimeStorage }

{ #category : #'*GToolkit4Famix3' }
MooseGroupRuntimeStorage >> gtByTypeFor: aView [
	<gtView>
	^ aView columnedList
		title: 'By type';
		items: [ byType associations collect: [:assoc | assoc key -> assoc value asMooseGroup ]];
		column: 'Type' text: [:assoc | assoc key gtDisplayString];
		column: 'Group' text: [:assoc | assoc value gtDisplayString];
		send: #value
]
