running
runAddCwR: assertPrintBar
	"self defaultTester runAddCwR: false"
	| memory |
	memory := ByteArray new: self concreteCompilerClass new machineCodeBytes.
	self concreteCompilerClass dataRegistersWithAccessorsDo:
		[:reg :rgetter :rsetter|
		self pairs: (-2 to: 2)  do:
			[:a :b| | inst len bogus |
			inst := self gen: AddCwR operand: a operand: reg.
			len := inst concretizeAt: 0.
			memory replaceFrom: 1 to: len with: inst machineCode object startingAt: 1.
			self processor
				reset;
				perform: rsetter with: (self processor convertIntegerToInternal: b).
			[[processor pc < len] whileTrue:
				[self processor singleStepIn: memory]]
				on: Error
				do: [:ex| ].
			"self processor printRegistersOn: Transcript.
			 Transcript show: (self processor disassembleInstructionAt: 0 In: memory); cr"
			assertPrintBar
				ifTrue: [self assert: processor pc = inst machineCodeSize.
						self assertCheckLongArithOpCodeSize: inst machineCodeSize]
				ifFalse: [bogus := processor pc ~= inst machineCodeSize].
			self concreteCompilerClass dataRegistersWithAccessorsDo:
				[:ireg :getter :setter| | expected |
				(self concreteCompilerClass isConcreteRISCTempRegister: ireg) ifFalse:
					[expected := getter == rgetter ifTrue: [b + a] ifFalse: [0].
					assertPrintBar
						ifTrue: [self assert: (self processor convertInternalToInteger: (self processor perform: getter)) equals: expected]
						ifFalse:
							[(self processor convertInternalToInteger: (self processor perform: getter)) ~= expected ifTrue:
								[bogus := true]]].
					assertPrintBar ifFalse:
						[Transcript
							nextPutAll: rgetter; nextPut: $(; print: b; nextPutAll: ') + '; print: a; nextPutAll: ' = ';
							print: (self processor convertInternalToInteger: (self processor perform: rgetter)); cr; flush.
						 bogus ifTrue:
							[self processor printRegistersOn: Transcript.
							 Transcript show: (self processor disassembleInstructionAt: 0 In: memory); cr]]]]]