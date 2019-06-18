Extension { #name : #FileReference }

{ #category : #'*GToolkit4Famix3-Delphi' }
FileReference >> delphiContents [
	^ [self readStreamDo: [:s | s converter: Latin1TextConverter new; contents]] 
		on: Error
		do: [ self readStreamDo: [:s | s contents] ]
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FileReference >> delphiSourceFiles [
	^ self files select: [ :each | #(pas dpr) includes: each extension ]
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FileReference >> fkDelphiAST [
	^ [DelphiParser parse: (self readStreamDo: [:s | s converter: Latin1TextConverter new; contents])]
	  on: Error do: [ DelphiParser parse: (self readStreamDo: [:s | s contents]) ]
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FileReference >> fkDelphiContents [
	^ [self readStreamDo: [:s | s converter: Latin1TextConverter new; contents]]
		on: Error 
		do: [ self readStreamDo: [:s | s contents] ]
]

{ #category : #'*GToolkit4Famix3-Delphi' }
FileReference >> fkDelphiFormAST [
	^ [DelphiFormParser parse: (self readStreamDo: [:s | s converter: Latin1TextConverter new; contents])]
	  on: Error do: [ DelphiFormParser parse: (self readStreamDo: [:s | s contents]) ]
]
