tests
testMoveMbrR
	"self new testMoveMbrR"
	self concreteCompilerClass registersWithNamesDo:
		[:sreg :srname|
		self concreteCompilerClass registersWithNamesDo:
			[:dreg :drname|
			((1 to: 19 by: 3) collect: [:po2| 2 raisedToInteger: po2]) do:
				[:offset| | inst len |
				inst := self gen: MoveMbrR operand: offset operand: sreg operand: dreg.
				len := inst concretizeAt: 0.
				self processor
					disassembleInstructionAt: 0
					In: inst machineCode object
					into: [:str :sz| | plainJane herIntended po |
						po := offset bitAnd: 1 << self processor bitsInWord - 1.
						plainJane := self strip: str.
						herIntended := 'movzbq ', (offset = 0 ifTrue: [''] ifFalse: ['0x', (po printStringBase: 16 length: 16 padded: true)]), '(', srname, '), ', drname.
						self assert: (plainJane match: herIntended).
						self assert: len = sz]]]]