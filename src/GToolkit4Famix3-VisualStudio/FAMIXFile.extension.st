Extension { #name : #FAMIXFile }

{ #category : #'*GToolkit4Famix3-VisualStudio' }
FAMIXFile >> compiledInProjects [
	<MSEProperty: #compiledInProjects type: #VSProjectFileCompile opposite: #file> <multivalued> <derived>
	^ self privateState 
			attributeAt: #compiledInProjects
			ifAbsentPut: [FMMultivalueLink on: self opposite: #file:]
]

{ #category : #'*GToolkit4Famix3-VisualStudio' }
FAMIXFile >> includedInProjects [
	<MSEProperty: #includedInProjects type: #VSProjectFileInclude opposite: #file> <multivalued> <derived>
	^ self privateState 
			attributeAt: #includedInProjects
			ifAbsentPut: [FMMultivalueLink on: self opposite: #file:]
]
