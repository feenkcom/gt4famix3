Class {
	#name : 'FAMIXPythonSourceLanguage',
	#superclass : 'FAMIXSourceLanguage',
	#category : 'GToolkit4Famix3-Python'
}

{ #category : 'accessing' }
FAMIXPythonSourceLanguage class >> annotation [
	<MSEClass: #PythonSourceLanguage super: #FAMIXSourceLanguage>
	<package: #FAMIX>
]

{ #category : 'accessing' }
FAMIXPythonSourceLanguage >> gtASTNodeFor: aString at: anInterval [
	| ast |
	ast := PythonParser parseWithErrors: aString.
	ast
		withAllNodesDo: [ :each | 
			(anInterval first <= each startPosition
				and: [ anInterval last = each stopPosition ])
				ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : 'accessing' }
FAMIXPythonSourceLanguage >> gtStyler [
	^ PythonParser gtStyler
]

{ #category : 'accessing' }
FAMIXPythonSourceLanguage >> isPython [
	^ true
]
