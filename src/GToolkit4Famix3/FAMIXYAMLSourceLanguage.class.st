Class {
	#name : #FAMIXYAMLSourceLanguage,
	#superclass : #FAMIXSourceLanguage,
	#category : #'GToolkit4Famix3-OpenApi'
}

{ #category : #accessing }
FAMIXYAMLSourceLanguage class >> annotation [
	<MSEClass: #YAMLSourceLanguage super: #FAMIXSourceLanguage>
	<package: #FAMIX>
]

{ #category : #accessing }
FAMIXYAMLSourceLanguage >> gtASTNodeFor: aString at: anInterval [
	| ast |
	ast := YAMLParser parseWithErrors: aString.
	ast
		withAllNodesDo: [ :each | 
			(anInterval first <= each startPosition
				and: [ anInterval last = each stopPosition ])
				ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : #accessing }
FAMIXYAMLSourceLanguage >> gtStyler [
	^ YAMLParser gtStyler
]
