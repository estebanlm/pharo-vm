initialization
ensureMultiThreadingOverridesAreUpToDate
	"Make sure the CoInterpreterMT switch methods are implemented.  These methods select
	 between CoInterpreterMT's implementation or CoInterpreter's implementation depending
	 on cogThreadManager being non-nil or nil respectively.  i.e. they allow us to use this one
	 simulator class to simulate for both CoInterpreterMT and CoInterpreter."
	| thisClass me mtInterpreterClass |
	thisClass := thisContext methodClass.
	mtInterpreterClass := thisClass superclass.
	me := thisClass name, '>>', thisContext method selector.
	"We want override switches for everything implemented by CoInterpreter
	 and CoInterpreterMT that is either not implemented by CogVMSimulator
	 or already implemented by CogVMSimulator as an override switch."
	(mtInterpreterClass selectors select:
		[:sel|
		(mtInterpreterClass superclass whichClassIncludesSelector: sel) notNil
		and: [(thisClass organization categoryOfElement: sel)
				ifNil: [true]
				ifNotNil: [:cat| cat == #'multi-threading simulation switch']]])
		do: [:sel| | argNames desiredSource |
			argNames := Parser new
							initPattern: (mtInterpreterClass sourceCodeAt: sel)
							return: [:pattern| pattern second].
			desiredSource := String streamContents:
								[:str|
								argNames isEmpty
									ifTrue: [str nextPutAll: sel]
									ifFalse:
										[sel keywords with: argNames do:
											[:kw :arg| str nextPutAll: kw; space; nextPutAll: arg; space].
										 str skip: -1].
								str
									crtab;
									nextPutAll: '"This method includes or excludes ', mtInterpreterClass name, ' methods as required.';
									crtab;
									nextPutAll: ' Auto-generated by ', me, '"';
									cr;
									crtab;
									nextPutAll: '^self perform: ';
									store: sel;
									crtab: 2;
									nextPutAll: 'withArguments: {'.
								argNames
									do: [:arg| str nextPutAll: arg]
									separatedBy: [str nextPut: $.; space].
								str
									nextPut: $};
									crtab: 2;
									nextPutAll: 'inSuperclass: (cogThreadManager ifNil: [';
									print: mtInterpreterClass superclass;
									nextPutAll: '] ifNotNil: [';
									print: mtInterpreterClass;
									nextPutAll: '])'].
			desiredSource ~= (thisClass sourceCodeAt: sel ifAbsent: ['']) asString ifTrue:
				[((thisClass includesSelector: sel)
				  and: [(thisClass compiledMethodAt: sel) messages includesAnyOf: #(halt halt:)])
					ifTrue: [self transcript cr; nextPutAll: 'WARNING, because of halts, not generating '; nextPutAll: desiredSource; cr; flush]
					ifFalse: [thisClass compile: desiredSource classified: #'multi-threading simulation switch']]].
	"Make sure obsolete CoInterpreterMT switch methods are deleted."
	((thisContext methodClass organization listAtCategoryNamed: #'multi-threading simulation switch') select:
		[:sel| (mtInterpreterClass whichClassIncludesSelector: sel) isNil]) do:
			[:sel| thisClass removeSelector: sel]