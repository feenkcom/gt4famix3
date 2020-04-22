Class {
	#name : #GtJSImporterExamples,
	#superclass : #GtImporterExamples,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #files }
GtJSImporterExamples >> demo_class_js [
	^ '
class MyClass {
    constructor() {
        this.iv1 = [];
        this.iv2 = [];
    }

    get variable1() {
        return this.iv1;
    }

    active() {
        return this.iv2.filter(item => item.isActive());
    }

    item(i) {
        return this.iv1[i];
    }
}

module.exports = MyClass;

'
]

{ #category : #files }
GtJSImporterExamples >> demo_subclass_js [
	^ '
class SubClass extends MyClass {
    constructor() {
        this.iv3 = [];
    }

    get variable3() {
        return this.iv3;
    }
}

module.exports = SubClass;

'
]

{ #category : #samples }
GtJSImporterExamples >> exampleImporter [
	<gtExample>
	| source |
	source := self exampleProject.
	^ GtJSImporter new importDirectory: source
]

{ #category : #files }
GtJSImporterExamples >> projectFiles [
	^ super projectFiles , 
	{
		{'demo/class.js'. self demo_class_js}.
		{'demo/subclass.js'. self demo_subclass_js}
	}
]
