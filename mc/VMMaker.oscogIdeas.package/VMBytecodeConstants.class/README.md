self ensureClassPool.
#(CtxtTempFrameStart LargeContextBit LargeContextSize SmallContextSize) do:
	[:k|
	self classPool declare: k from: ObjectMemory classPool]