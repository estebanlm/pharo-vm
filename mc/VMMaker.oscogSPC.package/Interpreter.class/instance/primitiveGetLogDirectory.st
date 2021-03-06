I/O primitives
primitiveGetLogDirectory
	"Primitive. Answer the VM's current log directory"
	| ptr sz stringOop |
	<var: 'ptr' type: 'char*'>
	<export: true>
	ptr := self ioGetLogDirectory.
	ptr == nil ifTrue:[^self success: false].
	sz := self strlen: ptr.
	stringOop := self instantiateClass: self classString indexableSize: sz.
	0 to: sz-1 do:[:i| self storeByte: i ofObject: stringOop withValue: (ptr at: i)].
	self pop: self methodArgumentCount+1.
	self push: stringOop.