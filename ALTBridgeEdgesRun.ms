/*
Bridge edges Alt component
MODIFY AT OWN RISK
- Adam Knight
*/

(
--specific to bridging 2 or more edges
erStat = showEndResult
showEndResult = false
setCommandPanelTaskMode #modify   
curSelStack = modpanel.getCurrentObject()  --Gets the current modifier.
obj = (getCurrentSelection())[1]

if (superClassOf $ == GeometryClass) then
	modClass = classOf (modPanel.getCurrentObject())

	if (modClass == Editable_Poly) then (
			obj.EditablePoly.popupDialog #BridgeEdge
	)
		
	if (modClass == Edit_Poly) then (
		obj.modifiers[#Edit_Poly].popupDialog #BridgeEdge
	)
	RedrawViews ()
)

