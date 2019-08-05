/*
Screw Creator 2.1

Screw creator allows the user to create and place screws on a given number of faces.
The user can also control the screw type, round or flat heads and screw size.
2.0 - improved UI design, added icons and re structured some internal code.
2.1 - Fixed small bug with missmatched buttons/screw types, added toolbar Icon

-Adam Knight
*/


(
try(destroyDialog screwme)catch()


rollout screwme "Screw Creator V.2.1" width:200 height:208
(
	global theBmp = "screwButtonImages_FLAT.bmp"
	GroupBox 'scrwpropgrp' "Screw Properties" pos:[8,8] width:184 height:88 align:#left
	GroupBox 'scrwtypegrp' "Screw Type" pos:[8,104] width:184 height:96 align:#left
	spinner 'spn1' "Screw Size (cm)  " pos:[16,32] width:86 height:16 range:[0,100,1] type:#float scale:1 align:#left
	checkbutton 'roundheads' "Round Heads" pos:[16,56] width:168 height:32 align:#left
	button 'phillipsbtn' "Phillips" pos:[50,121] width:30 height:30 images:#("screwButtonImages_FLAT.bmp", "screwButtonImages_A.bmp", 11, 2, 11, 1, 1) align:#left
	button 'slottedbtn' "Slotted" pos:[15,121] width:30 height:30 images:#("screwButtonImages_FLAT.bmp", "screwButtonImages_A.bmp", 11, 1, 11, 1, 1) align:#left
	button 'hexbtn' "Hex" pos:[85,121] width:30 height:30 images:#("screwButtonImages_FLAT.bmp", "screwButtonImages_A.bmp", 11, 3, 11, 1, 1) align:#left
	button 'studbtn' "Stud" pos:[120,121] width:30 height:30 images:#("screwButtonImages_FLAT.bmp", "screwButtonImages_A.bmp", 11, 4, 11, 1, 1) align:#left
	button 'torxbtn' "Torx" pos:[155,121] width:30 height:30 images:#("screwButtonImages_FLAT.bmp", "screwButtonImages_A.bmp", 11, 5, 11, 1, 1) align:#left
	button 'pozibtn' "Pozi" pos:[15,161] width:30 height:30 images:#("screwButtonImages_FLAT.bmp", "screwButtonImages_A.bmp", 11, 6, 11, 1, 1) align:#left
	button 'nutbtn' "Nut" pos:[50,161] width:30 height:30 images:#("screwButtonImages_FLAT.bmp", "screwButtonImages_A.bmp", 11, 7, 11, 1, 1) align:#left
	button 'boltbtn' "Bolt" pos:[85,161] width:30 height:30 images:#("screwButtonImages_FLAT.bmp", "screwButtonImages_A.bmp", 11, 8, 11, 1, 1) align:#left
	button 'crossbltbtn' "Cross Bolt" pos:[120,161] width:30 height:30 images:#("screwButtonImages_FLAT.bmp", "screwButtonImages_A.bmp", 11, 9, 11, 1, 1) align:#left
	button 'slotbltbtn' "Slot Bolt" pos:[155,161] width:30 height:30 images:#("screwButtonImages_FLAT.bmp", "screwButtonImages_A.bmp", 11, 10, 11, 1, 1) align:#left

	

-- randomizes the screw rotation
fn randzrot = (
	randz = random 0.0 360.0
	currentMatrix = $.transform
	preRotate currentMatrix (eulertoquat (eulerAngles 0 0 randz))
	$.transform = currentMatrix
)

global obj = selection[1]
global screwType = (Flat_Cross)

 -- creates the screw at location and applies correct screw type

fn createRandScrew = (

			-- converts object to editable poly
		if (classof (modPanel.getCurrentObject()) == Editable_Poly) then (print "Is Editable Poly") else (if querybox "This will collapse your modifier stack do you want to continue?" beep:false then (convertToPoly selection[1]) else (print "Did nothing"))
			
			-- gets the number of selected faces
			
		subObjectLevel = 4
		faces = ((polyop.getfaceselection obj) as array)
			
		for I in faces do (
			facepos = polyop.getfacecenter obj I
			facenorm = polyop.getfacenormal obj I
			screwType pos: facepos dir: facenorm size: spn1.value isSelected: on
			--randomizes the rotation
			randzrot()
			select obj
			subObjectLevel = 4
		)
)


-- changes images to round/flat heads when roundheads is pressed
	on roundheads changed theState do
	(
		if theState then
		(
			global theBmp = "screwButtonImages_ROUND.bmp"
			phillipsbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,2,11,1,1 )
			slottedbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,1,11,1,1 )
			hexbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,3,11,1,1 )
			studbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,4,11,1,1 )
			torxbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,5,11,1,1 )
			pozibtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,6,11,1,1 )
			nutbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,7,11,1,1 )
			boltbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,8,11,1,1 )
			crossbltbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,9,11,1,1 )
			slotbltbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,10,11,1,1 )
				print "round on"
		)
		else
		(
			global theBmp = "screwButtonImages_Flat.bmp"
			phillipsbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,2,11,1,1 )
			slottedbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,1,11,1,1 )
			hexbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,3,11,1,1 )
			studbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,4,11,1,1 )
			torxbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,5,11,1,1 )
			pozibtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,6,11,1,1 )
			nutbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,7,11,1,1 )
			boltbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,8,11,1,1 )
			crossbltbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,9,11,1,1 )
			slotbltbtn.images = #(theBmp,"screwButtonImages_A.bmp" , 11,10,11,1,1 )
			print"round off"
		)
	)	

	
	on phillipsbtn pressed do
	(
			if (roundheads.state == false) then (
				screwType = Flat_Cross
				createRandScrew()
			)
			
			else (
				screwType = Round_Cross
				createRandScrew()
			)
	)
	
	on slottedbtn pressed do
	(
			if (roundheads.state == false) then (
				screwType = Flat_Cross
				createRandScrew()
			)
			
			else (
				screwType = Round_Slotted
				createRandScrew()
			)
	)
	
	on hexbtn pressed do
	(
			if (roundheads.state == false) then (
				screwType = Flat_Hex
				createRandScrew()
			)
			
			else (
				screwType = Round_Hex
				createRandScrew()
			)
	)
	
	on studbtn pressed do
	(
			if (roundheads.state == false) then (
				screwType = Flat_Stud
				createRandScrew()
			)
			
			else (
				screwType = Round_Stud
				createRandScrew()
			)
	)
	
	on torxbtn pressed do
	(
			if (roundheads.state == false) then (
				screwType = Flat_Torx
				createRandScrew()
			)
			
			else (
				screwType = Round_Torx
				createRandScrew()
			)
	)
	
	on pozibtn pressed do
	(
			if (roundheads.state == false) then (
				screwType = Flat_Pozi
				createRandScrew()
			)
			
			else (
				screwType = Round_Pozi
				createRandScrew()
			)
	)
	
	on nutbtn pressed do
	(
			screwType = Nut
			createRandScrew()
	)
	
	on boltbtn pressed do
	(
			if (roundheads.state == false) then (
			screwType = Flat_Bolt
			createRandScrew()
			)
		
		else (
			screwType = Round_Bolt
			createRandScrew()
			)
	)
	
	on crossbltbtn pressed do
	(
			screwType = Cross_Bolt
			createRandScrew()
	)
	
	on slotbltbtn pressed do
	(
			screwType = Slot_Bolt
			createRandScrew()
	)
	
)

createdialog screwme
)