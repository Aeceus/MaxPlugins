macroScript Bridge_Edges
Category: "AO"
tooltip: "Bridge Edges"
--icon:
silentErrors: false
autoUndoEnabled: true

(
	/*
	Screw Creator 2.2

	Screw creator allows the user to create and place screws on a given number of faces.
	The user can also control the screw type, round or flat heads and screw size.
	2.0 - improved UI design, added icons and re structured some internal code.
	2.1 - Fixed small bug with missmatched buttons/screw types, added toolbar Icon
	2.2 - Separated working code from macroscript and added to AO Tools Workspace
		- Added ability to close tool by switching sub object level and by clicking on the tool again

	-Adam Knight
	*/


	global callbackOpen = false, new	--Used to open/close the tool when required

	-- makes tool available only in edges mode.	
	on isVisible do subObjectLevel == 2


	on execute do (
		callbackOpen = true
		fileIn ((pathConfig.GetDir #userScripts) + "\\AOTools\\BridgeEdgesRun.ms")
		
	)

	on altexecute type do (
		
		fileIn ((pathConfig.GetDir #userScripts) + "\\AOTools\\ALTBridgeEdgesRun.ms")
	)

	on isChecked do callbackopen
		
	on closeDialogs do (
		--cleaning operation to remove all working parts of script after use.
		max move
		callbackOpen = false
		free edgeList
		Global EDpolycallbackItem = undefined
		Global EpolycallbackItem = undefined
		GC Light:true
		Obj = undefined
	)

)

