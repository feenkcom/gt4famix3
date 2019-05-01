Extension { #name : #MooseGroup }

{ #category : #'*GToolkit4Famix3' }
MooseGroup >> gtDisplayOn: stream [
	stream 
			nextPutAll: self description; 
			space; 
			nextPut: $(; 
			print: self size;
			nextPut: $)
]
