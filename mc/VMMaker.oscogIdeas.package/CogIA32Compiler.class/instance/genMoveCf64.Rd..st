abstract instructions
genMoveCf64: constantFloat64 Rd: register
	<inline: true>
	<returnTypeC: #'AbstractInstruction *'>
	<var: #constantFloat64 type: #double>
	| inst |
	inst := cogit PushC64: constantFloat64 asIEEE64BitWord.
	cogit PopRd: register.
	^ inst