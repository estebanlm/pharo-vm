inline primitive support
genLcIsFloatObject: objectReg to: valueReg
	<option: #LowcodeVM>
	"TODO: Implement this one"
	cogit MoveCq: 1 R: valueReg.
	cogit ssPushNativeRegister: valueReg.