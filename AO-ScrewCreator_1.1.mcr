macroScript Screw_Creator
Category: "AO"
tooltip: "Screw Creator"
icon: "ScrewCreator_ICN.png"
silentErrors: false
autoUndoEnabled: true

(
/*
Screw Creator 2.1

Screw creator allows the user to create and place screws on a given number of faces.
The user can also control the screw type, round or flat heads and screw size.
2.0 - improved UI design, added icons and re structured some internal code.
2.1 - Fixed small bug with missmatched buttons/screw types, added toolbar Icon

-Adam Knight
*/

	try(destroyDialog UVCompiler)catch()
	fileIn ((pathConfig.GetDir #userScripts) + "\\AOTools\\ScrewCreatorRun.ms")
)
