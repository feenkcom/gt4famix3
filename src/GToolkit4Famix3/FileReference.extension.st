Extension { #name : #FileReference }

{ #category : #'*GToolkit4Famix3' }
FileReference >> isInMavenDirectory [
	self isMavenDirectory ifTrue: [ ^ true ].
	self parent isNil ifTrue: [ ^ false ].
	^ self parent isInMavenDirectory
]

{ #category : #'*GToolkit4Famix3' }
FileReference >> isMavenDirectory [
	^ self isDirectory and: [ 
		self files anySatisfy: [ :file | file basename = 'pom.xml' ] ]
]

{ #category : #'*GToolkit4Famix3' }
FileReference >> mavenDirectory [
	self isMavenDirectory ifTrue: [ ^ self ].
	self parent isNil ifTrue: [ ^ nil ].
	^ self parent mavenDirectory
]

{ #category : #'*GToolkit4Famix3' }
FileReference >> parentMavenPom [
	^ self mavenDirectory 
		ifNotNil: [ :directory | directory / 'pom.xml' ]
]
