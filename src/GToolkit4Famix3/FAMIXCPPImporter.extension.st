Extension { #name : #FAMIXCPPImporter }

{ #category : #'*GToolkit4Famix3' }
FAMIXCPPImporter >> gtClassesFor: aView [
	<gtView>
	^ aView list
		priority: 10;
		title: 'Classes';
		items: [ classes values sorted: [ :a :b | a mooseName < b mooseName ] ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXCPPImporter >> gtEnumsFor: aView [
	<gtView>
	^ aView list
		priority: 30;
		title: 'Enums';
		items: [ enums values sorted: [ :a :b | a mooseName < b mooseName ] ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXCPPImporter >> gtStructsFor: aView [
	<gtView>
	^ aView list
		priority: 20;
		title: 'Structs';
		items: [ structs values sorted: [ :a :b | a mooseName < b mooseName ] ]
]

{ #category : #'*GToolkit4Famix3' }
FAMIXCPPImporter >> gtUnionsFor: aView [
	<gtView>
	^ aView list
		priority: 40;
		title: 'Unions';
		items: [ unions values sorted: [ :a :b | a mooseName < b mooseName ] ]
]
