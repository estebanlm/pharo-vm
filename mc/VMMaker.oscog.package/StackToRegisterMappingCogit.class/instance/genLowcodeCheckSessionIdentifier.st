inline primitive generators generated code
genLowcodeCheckSessionIdentifier
	<option: #LowcodeVM>
	<inline: true>
	"Generated by the Lowcode instruction generator."
	| expectedSession |
	expectedSession := extA.

	self ssPushNativeConstantInt32: (expectedSession = coInterpreter getThisSessionID ifTrue: [1] ifFalse: [0]).

	extA := 0.
	^ 0

