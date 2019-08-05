macroScript MeshTidy
Category: "AO"
tooltip: "MeshTidy"
icon: "MeshTidy_ICN.png"
silentErrors: false
autoUndoEnabled: true

(
/*
MeshTidy 1.6
Created by adam knight
Simple tool that finds and deletes turbo smooths, collapses geometry stacks and converts to editable poly.
Can also open up the exporter for selected/all objects if need be to smooth workflow.

1.1 added ability to choose to reset transforms and center the objects pivot. This is optional incase objects have specific pivot points. also added icons
1.2 Also removes nurms smoothing and will never reset pivots or rotations for dummy objects
1.3 fixed bugs that was stopping the script from freezing transforms properly
1.4 Fixed a bug that would allow animation to come through from cinema4D that shouldn't be there. This shouldstop meshes being translated when coming back in to cinema. Hopefully.
1.5 Bug Fixes sub surf divide now always turns off.
1.6  Added removing animation as an option and setting the Y of objects up too, removed the export function in preparation for new tools, fixed a bug where animation wasn't being deleted from nulls
*/

	fileIn ((pathConfig.GetDir #userScripts) + "\\AOTools\\MeshTidyRun.ms")
)