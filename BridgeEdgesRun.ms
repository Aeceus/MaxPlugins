/*
Bridge edges main component
MODIFY AT OWN RISK
- Adam Knight
*/

(
local edgeList = #{} -- lists selected edges in the EdgePicker/Active Bridge mode.
Global EDpolycallbackItem -- Editable Poly Callback Handler
Global EpolycallbackItem -- Edit Poly Callback Handler

--specific to bridging 2 or more edges
erStat = showEndResult
showEndResult = false
setCommandPanelTaskMode #modify
Global curSelStack = modpanel.getCurrentObject()  --Gets the current modifier.	
Global obj = (getCurrentSelection())[1] -- currently selected object
Global getEdges = #()

	
	
	fn Epolypickededges ev nd = (
		
		-- used to get the current modifier
		obj = selection[1]
		if (superClassOf obj == GeometryClass) then
		modClass = classOf (modPanel.getCurrentObject())
		max select
			
			
		if (modClass == Edit_Poly) and (SubObjectLevel == 2) then (
			getEdges = ((obj.modifiers [#Edit_Poly].getSelection #Edge) as array)[1]
			
			if (getedges == undefined) then (
				--checks if bit returned value is undefined
				Format "Selection Undefined"
			)
			
			else (
				appendifunique edgeList getEdges 
					--appends bitarray edge to edge list only if it isn't already in there.
					
				if (edgeList.numberSet == 2) then (
					--Resets the bridge operation to only bridge with a single face
					obj.modifiers[#Edit_Poly].SetOperation #BridgeEdge
					obj.modifiers[#Edit_Poly].bridgeSegments = 1
					--bridges the selected edges in active bridge
					obj.modifiers[#Edit_Poly].Select #Edge edgeList
					obj.modifiers[#Edit_Poly].buttonOp #BridgeEdge
					obj.modifiers[#Edit_Poly].SetBridgeNode obj
					obj.modifiers[#Edit_Poly].Commit ()
					obj.modifiers[#Edit_Poly].Select #Edge edgeList select:off
					redrawViews()
					free edgeList
				)
			)
		)
		
		else (
			--closes the callback if the selection level or modifier type changes
			max move
			free edgeList
			Global callbackOpen = false
			callbackItem = undefined
			EpolycallbackItem = undefined
			gc light:true
			Obj = undefined
		)
	)

	fn EDpolypickededges ev nd = (
		
		-- used to get the current modifier
		obj = selection[1]
		if (superClassOf obj == GeometryClass) then
		modClass = classOf (modPanel.getCurrentObject())
		max select
			
			
		if (modClass == Editable_Poly) and (SubObjectLevel == 2) then ( 
			getedges = (polyop.getEdgeSelection obj) -- gets edge selection of current object
			newedge = ((getedges as array)[1]) -- gets first bit in array
			
			--checks if bit array is undefined if it is it does not add it to the array.
			if (newedge == undefined) then (print "cannot add to selection")
			
			else (
				appendifunique edgelist newedge --appends bitarray edge to edge list only if it isn't already in there.

				if (edgeList.numberSet == 2) then (
					polyop.setEdgeSelection obj edgeList
					obj.bridgeSegments = 1
					obj.EditablePoly.Bridge ()
					polyop.setEdgeSelection obj #{}
					redrawViews()
					free edgeList
				)
			)
		)
			
		else (
			--closes the callback if the selection level or modifier type changes
			max move
			free edgeList
			Global callbackOpen = false
			callbackItem = undefined
			EDpolycallbackItem = undefined
			gc light:true
			Obj = undefined
		)
	)



if (superClassOf $ == GeometryClass) then
	modClass = classOf (modPanel.getCurrentObject())
		
	if (modClass == Edit_Poly) then (
		
		if ((subObjectLevel == 2) and ((((curSelStack.getSelection #Edge) as array).count) <=1)) then (
			
			max select
			escapeEnable = false --stops the user exiting without stopping the callback
			
			-- gets the first edge if there is one and adds it to the array pre emptively
			if ((((curSelStack.getSelection #Edge) as array).count) ==1) do (
				getfirstedge = (((curSelStack.getSelection #Edge) as array)[1])
				append edgeList getfirstedge
			)
			
			EpolycallbackItem = NodeEventCallback mouseup:false delay:0 SubObjectSelectionChanged: Epolypickededges
		)
		
		else if ((subObjectLevel = 2) and ((((curSelStack.getSelection #Edge) as array).count) >=2)) then (
			obj.modifiers[#Edit_Poly].SetOperation #BridgeEdge
			obj.modifiers[#Edit_Poly].bridgeSegments = 1
			obj.modifiers[#Edit_Poly].buttonOp #BridgeEdge
			obj.modifiers[#Edit_Poly].SetBridgeNode obj
			obj.modifiers[#Edit_Poly].Commit ()
			free edgeList
			Global callbackOpen = false
			gc light:true
		)
	)
	
	else if (modClass == Editable_Poly) then (
		
		if ((subObjectLevel == 2) and ($.selectedEdges.count <= 1)) then (
			
			max select
			escapeEnable = false --stops the user exiting without stopping the callback
			
			-- gets the first edge if there is one and adds it to the array pre emptively
			if (obj.selectedEdges.count == 1) do (
				getfirstedge = (polyop.getEdgeSelection obj)
				newfirstedge = ((getfirstedge as array)[1])
				append edgeList newfirstedge
			)
			
			EDpolycallbackItem = NodeEventCallback mouseup:false delay:0 enabled:true SubObjectSelectionChanged: EDpolypickededges
		)
		
		else if ((subObjectLevel = 2) and ($.selectedEdges.count >= 2)) then (
			obj.bridgeSegments = 1
			obj.EditablePoly.Bridge ()
			free edgeList
			Global callbackOpen = false
			gc light:true
		)
	)
)
