Extension { #name : #FAMIXSourceAnchor }

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceAnchor >> gtAddLinksTo: text [
	
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceAnchor >> gtCompleteSourceFor: aView [
	<gtView>
	^ self gtSourceFor: aView
]

{ #category : #'*GToolkit4Famix3' }
FAMIXSourceAnchor >> gtSourceFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Source';
		priority: 10;
		aptitude: BrGlamorousCodeEditorAptitude;
		text: [ self sourceText ]
]
