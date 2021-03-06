C translation
generateValueAsArgument: aTSendNode on: aStream indent: level
	"Reduce [:formal ... :formalN| body ] value: actual ... value: actualN
	 to body with formals substituted for by actuals."
	| substitution substitutionDict newLabels |
	self assert: aTSendNode receiver isStmtList.
	self assert: aTSendNode receiver args size = aTSendNode args size.
	substitution := aTSendNode receiver copy.
	substitution renameLabelsForInliningInto: currentMethod.
	substitutionDict := Dictionary new: aTSendNode args size * 2.
	aTSendNode receiver args with: aTSendNode args do:
		[ :argName :exprNode |
		substitutionDict at: argName put: exprNode].
	substitution
		bindVariablesIn: substitutionDict;
		emitCCodeAsArgumentOn: aStream level: level generator: self.
	newLabels := Set withAll: currentMethod labels.
	substitution nodesDo:
		[:node| node isLabel ifTrue: [node label ifNotNil: [:label| newLabels add: label]]].
	"now add the new labels so that a subsequent inline of
	 the same block will be renamed with different labels."
	currentMethod labels: newLabels