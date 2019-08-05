macroScript removePlus
Category: "AO"
tooltip: "Remove Plus"
--icon: #()
silentErrors: false
autoUndoEnabled: true


/*
Bridges Edges 1.1
Quick macro that automatically deletes edges and vertices by default with one button can also delete just edges.
-Adam Knight
*/

(
	on isVisible do SubObjectLevel == 2 or SubObjectLevel == 1
		
	on Execute do (
		obj = selection[1]
		setCommandPanelTaskMode #modify
		curSelStack = modpanel.getCurrentObject()
		
		if (superClassOf $ == GeometryClass) then
		modClass = classOf (modPanel.getCurrentObject())
			
			
		if (modClass== Edit_poly) then (
				
				
			if (SubObjectLevel == 2) then (
			obj.modifiers[#Edit_Poly].ButtonOp #RemoveEdgeRemoveVertices
			)
				
			if(SubObjectLevel == 1) then (
			obj.modifiers[#Edit_Poly].ButtonOp #RemoveVertex
			)
				
			else if (SubObjectLevel==3 or SubObjectLevel==4 or SubObjectLevel==5) then (print "cannot remove")
		)
			
		if (modClass== Editable_Poly) then (
			print "is Editable Poly"
			obj.convertSelection #CurrentLevel #Vertex
			obj.editablePoly.Remove ()
			subobjectLevel = 1
			obj.editablePoly.Remove ()
			subobjectLevel = 2
		)
		redrawViews()
		print "Views Redrawn"
	)

	on altExecute type do (
		obj = selection[1]
		setCommandPanelTaskMode #modify
		curSelStack = modpanel.getCurrentObject()
		
		if (superClassOf $ == GeometryClass) then
		modClass = classOf (modPanel.getCurrentObject())
		
		
		if (modClass== Edit_poly) then (
		
			if (SubObjectLevel == 2) then (
			obj.modifiers[#Edit_Poly].ButtonOp #RemoveEdge
			)
				
			if(SubObjectLevel == 1) then (
			obj.modifiers[#Edit_Poly].ButtonOp #RemoveVertex
			)
				
			else if (SubObjectLevel==3 or SubObjectLevel==4 or SubObjectLevel==5) then (print "cannot remove")
		)

		if (modClass== Editable_Poly) then (
			if (SubObjectLevel == 2 or SubObjectLevel == 1) then (obj.editablePoly.Remove ())
			else if (subObjectLevel == 3 or SubObjectLevel==4 or SubObjectLevel==5) then print "cannot remove"
		)
	)	
)