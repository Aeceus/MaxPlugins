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


try(DestroyDialog MeshTidy)catch()	

rollout MeshTidy "MeshTidy" width:160 height:216
(
	label 'WarningLabel' "Save work before use!" pos:[24,8] width:112 height:16 align:#left
	checkbox 'isSelected' "Selected only" pos:[16,40] width:128 height:24 align:#left
	checkbox 'Yup' "Y-up" pos:[16,136] width:128 height:24 align:#left
	button 'cleanMe' "Cinema Ready" pos:[8,176] width:144 height:32 align:#left
	GroupBox 'settingsGroup' "Settings" pos:[8,24] width:144 height:144 align:#left
	checkbox 'resettrans' "Reset X Form" pos:[16,64] width:128 height:24 align:#left
	checkbox 'CenterPivot' "CenterPivot" pos:[16,88] width:128 height:24 align:#left
	checkbox 'RemoveAnim' "Remove Animation" pos:[16,112] width:128 height:24 align:#left
	
	global rot = eulerangles 90 0 0
	global looseChildren = #()
	global i = undefined

		-- used to get the current modifier
	fn getModPanel = (
		obj = Selection[1]
		if (superClassOf obj == GeometryClass) then
		global modClass = classOf (modPanel.getCurrentObject())
	)

	

	on cleanMe pressed do
	(
		
		if (isSelected.checked == on) then (
			
			--gets current selection as a snapshot and then takes only the geom from that selection to use for cleaning.
			finalSel = ((selection) as array)
			selectionSnap = (for o in finalSel where superClassOf o == geometryClass collect o)
			
			macros.run "Tools" "PivotMode_Toggle"
			--Deletes animation
			if (RemoveAnim.checked == on) do (
				for I in finalSel do (
					deleteKeys I
				)
			)
			macros.run "Tools" "PivotMode_Toggle"
			
			for OBJ in selectionSnap do (
				print ("Cleaning Mesh "+ OBJ.name as string)
				
				--turns of nurms smoothing
				if (classof OBJ == Editable_Poly) then (OBJ.surfSubdivide = off)
				
				--deletes turbosmooth modifier from object
				for index = OBJ.modifiers.count to 1 by -1 do (
					if ((classOf OBJ.modifiers[index]) == TurboSmooth) do (deleteModifier OBJ index )
				)
				
				--centerspivot
				if (CenterPivot.checked == on) do (OBJ.Pivot = OBJ.Center)
				
				--resetstransformations
				if (resettrans.checked == on) do (
					resetXform OBJ
					resetTransform OBJ
				)
					
				/*collapses modifier stack and converts the object to editable poly and finally 
				ensures the subdivide surface is turned off before resetting the objects scale.*/
					
				CollapseStack OBJ
				ConvertTo OBJ Editable_Poly
				OBJ.surfSubdivide = off
				resetScale OBJ
			)
			
			--Rotates dummy's so that Y is upwards and will stay upwards in cinema
			if (Yup.checked == true) do (
				for i in finalSel do (
						if classof i == dummy do (
						print i
						chl = i.children
						
						for c in chl do (
							append looseChildren c
							c.parent = undefined
						)
						
						i.rotation.X_rotation = 0
						i.rotation.Y_rotation = 0
						i.rotation.Z_rotation = 0
						rotate i rot
						
						for L in loosechildren do (
							L.parent = i
						)
					)
					free looseChildren
				)
			)
			print "Operation Complete"
		)
		
		else (
			
			macros.run "Tools" "PivotMode_Toggle"
			--Deletes animation
			if (RemoveAnim.checked == on) do (
				for I in Objects do (
					deleteKeys I
				)
			)
			macros.run "Tools" "PivotMode_Toggle"
			
			for OBJ in Geometry do (
				print ("Cleaning Mesh "+ OBJ.name as string)
				
				--deleted turbosmooth from modifier stack
				for index = OBJ.modifiers.count to 1 by -1 do (
					if ((classOf OBJ.modifiers[index]) == TurboSmooth) do (deleteModifier OBJ index ) 
				)
				
				--turns of nurms smoothing
				if (classof OBJ == Editable_Poly) then (OBJ.surfSubdivide = off)
				
				--centerspivot
				if (CenterPivot.checked == on) do (OBJ.Pivot = OBJ.Center)
				
				--resetstransformations
				if (resettrans.checked == on) do (
					resetXform OBJ
				)
				
				/*collapses modifier stack and converts the object to editable poly and finally 
				ensures the subdivide surface is turned off before resetting the objects scale.*/
				CollapseStack OBJ
				ConvertTo OBJ Editable_Poly
				OBJ.surfSubdivide = off
				resetScale OBJ
			)
			
			--Rotates dummy's so that Y is upwards and will stay upwards in cinema
			if (Yup.checked == on) do (
				for i in Objects do (
					if classof i == dummy do (
						chl = i.children
						for c in chl do (
							append looseChildren c
							c.parent = undefined
						)
						i.rotation.X_rotation = 0
						i.rotation.Y_rotation = 0
						i.rotation.Z_rotation = 0
						rotate i rot
						for L in loosechildren do (
							L.parent = i
						)
					)
				free looseChildren
				)
			)
		)
		messageBox "Clean up complete. Please check your PIVOT rotations before continuing on to Cinema4D." title: "Clean up complete!"
	)
)

CreateDialog MeshTidy
