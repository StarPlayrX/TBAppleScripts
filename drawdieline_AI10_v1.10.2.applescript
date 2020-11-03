-- DRAW DIELINE v1.10.2
-- script by todd bruss ©Ê2005, donationware
-- Macthis Prepress Software
-- send donations via Paypal to toddnan@bellsouth.net

-- v1.10.2
-- shortened up code, introduced subroutines

-- Requires Adobe Illustrator v10

property uilabel_h : 8
property uilabel_w : "1 2 3"
property doc_units : "inches"
property noprint_margin : ".1875 .1875 .25 .25"
property skip : "Ok"


set x to display dialog "die measurements:" buttons {"millimeters", "inches"} default button doc_units

on convert(x, y)
	-- declare global to get z back out of subroutine
	global z
	-- set z incase no if's change are true
	set z to y
	
	-- convert last result from inches to mm
	if button returned of x = "millimeters" and doc_units = "inches" then
		set z to ((z) as number) * 25.4
		set z to z as string
	end if
	
	-- convert last result from mm to inches
	if button returned of x = "inches" and doc_units = "millimeters" then
		set z to ((z) as number) / 25.4
		set z to z as string
	end if
	
	-- send z back out of subroutine
	return z
end convert

convert(x, uilabel_h)
set uilabel_h to z

convert_list(x, uilabel_w)
set uilabel_w to z

convert_list(x, noprint_margin)
set noprint_margin to z

on convert_list(x, y)
	global z
	set z to y
	
	-- convert last result from inches to mm (uilabel_w or no_print Margin)
	if button returned of x = "millimeters" and doc_units = "inches" then
		set y to z
		-- reset z 
		set z to ""
		set AppleScript's text item delimiters to " "
		set y to text items of y
		set AppleScript's text item delimiters to ""
		repeat with i from 1 to count of y
			set item i of y to (item i of y as number) * 25.4
			if z = "" then
				set z to item i of y as string
			else
				set z to z & " " & item i of y as string
			end if
		end repeat
	end if
	
	if button returned of x = "inches" and doc_units = "millimeters" then
		set y to z
		-- reset z
		set z to ""
		set AppleScript's text item delimiters to " "
		set y to text items of y
		set AppleScript's text item delimiters to ""
		repeat with i from 1 to count of y
			set item i of y to (item i of y as number) / 25.4
			if z = "" then
				set z to item i of y as string
			else
				set z to z & " " & item i of y as string
			end if
		end repeat
	end if
	
	return z
end convert_list

set doc_units to the button returned of x
if doc_units = "inches" then
	set unit_label to "\""
	set unit_maker to 1
else
	set unit_label to "mm"
	set unit_maker to 25.4
end if

display dialog "Label Height/Cutoff of 1up, using " & doc_units & "." default answer uilabel_h
set uilabel_h to the text returned of the result
set label_h to uilabel_h
if label_h as number = 0 then
	display dialog "I know you are a ZERO, but what am I?" buttons {"Cancel"} default button 1 with icon 0
end if
if label_h as number < 0 then
	display dialog "Quit thinking so negatively!" buttons {"Cancel"} default button 1 with icon 1
end if


display dialog "set Panels:1 (space) 2 (space) 3...using " & doc_units & "." default answer uilabel_w

-- turns this stuff into a list
set uilabel_w to the text returned of the result
set label_w to uilabel_w
set AppleScript's text item delimiters to " "
set label_w to text items of label_w
set AppleScript's text item delimiters to ""


-- No print Margin and sleeve specs
-- v1.09 no print margin
set test to (display dialog "Set No Print Margin for Sleeves:" & return & "TOP BOTTOM LEFT RIGHT" & return & "using " & doc_units & "." with icon 1 default answer noprint_margin buttons {"Skip", "Ok"} default button skip)
-- remembers what you did last
set noprint_margin to text returned of test
set skip to button returned of test

-- calulate document width
set count_w to count of label_w
set doc_w to 0
repeat with x from 1 to count_w
	if (item x of label_w as number) = 0 then
		display dialog "Hey ZERO, check your numbers!" buttons {"Cancel"} default button 1 with icon 2
	end if
	if (item x of label_w as number) < 0 then
		display dialog "Go see a Shrink and check your numbers!" buttons {"Cancel"} default button 1 with icon 0
	end if
	
	set doc_w to doc_w + (item x of label_w as number)
end repeat

set doc_web to doc_w as text
-- Get half of web and check for integer to prevent the annoying ".0" as end when it is not needed
set doc_halfling to (doc_w / 2) as text
if doc_halfling ends with ".0" then
	set doc_half to (doc_halfling as integer) as text
else
	set doc_half to doc_halfling as text
end if
set doc_w to doc_w * 72 / unit_maker
set doc_h to (label_h as number) * 72 / unit_maker



tell application "Adobe Illustrator"
	activate
	-- create a document with CMYK color space
	set my_doc to make new document with properties {Çclass caCSÈ:Çconstant eCLSeCyMÈ, Çclass pSHhÈ:doc_h, Çclass pSHwÈ:doc_w}
	set newSpot to make new Çclass caCCÈ in document 1 with properties Â
		{name:"die", color:{Çclass CYANÈ:25.0, Çclass MAGNÈ:75.0, Çclass YELLÈ:0.0, Çclass BLAKÈ:0.0}, Çclass paCTÈ:Çconstant eCMde427È}
	set Çclass DiSCÈ of document 1 to {Çclass caCCÈ:newSpot, Çclass TINTÈ:100.0}
	set Çclass DiFCÈ of document 1 to {class:Çclass tGRiÈ, Çclass GRAYÈ:0.0}
end tell

-- initialize matrix variables for boxes
set a1 to 0
set b1 to 0
set c1 to 0
set d1 to 0

on box(a1, b1, c1, d1)
	tell application "Adobe Illustrator"
		make new Çclass shRCÈ at beginning of document 1 Â
			with properties {bounds:{a1, b1, c1, d1}, Çclass aiFPÈ:false, Çclass aiNTÈ:"gt_box1"}
	end tell
end box

on crop(a, b, c, d)
	tell application "Adobe Illustrator"
		make new Çclass caPAÈ at beginning of document 1 Â
			with properties {Çclass aiSPÈ:true, Çclass aiFPÈ:false, Çclass aiEPÈ:{{Çclass pAncÈ:{a, b}, Çclass caCRÈ:Çconstant ePTye057È}, {Çclass pAncÈ:{c, d}, Çclass caCRÈ:Çconstant ePTye057È}}}
	end tell
end crop

on arrow(a, b, c, d, e, f)
	tell application "Adobe Illustrator"
		make new Çclass caPAÈ at beginning of document 1 Â
			with properties {Çclass aiSPÈ:true, Çclass aiFPÈ:false, Çclass aiEPÈ:{{Çclass pAncÈ:{a, b}, Çclass caCRÈ:Çconstant ePTye057È}, {Çclass pAncÈ:{c, d}, Çclass caCRÈ:Çconstant ePTye057È}, {Çclass pAncÈ:{e, f}, Çclass caCRÈ:Çconstant ePTye057È}}}
	end tell
end arrow


set a1 to 0
set b1 to (label_h as number) * 72 / unit_maker
set c1 to (item 1 of label_w as number) * 72 / unit_maker
set d1 to 0
-- calculate
set the_count to count of label_w

-- draw 1st box
box(a1, b1, c1, d1)

-- top left dim crop marks (h)
crop(-9, b1, -27, b1)

-- top left dim arrow marks (v)
arrow(-14, b1 - 9, -18, b1, -22, b1 - 9)
-- bottom left dim arrow marks (v)
arrow(-14, 9, -18, 0, -22, 9)

-- bottom left dim arrow marks (v)
crop(-18, b1, -18, 0)

-- bottom left dim crop marks (h)
crop(-9, 0, -27, 0)

--- LOWER DIM LINE
crop(a1, -9, a1, -27)
crop(a1, -18, c1, -18)
crop(c1, -9, c1, -27)

---- Lower line arrowheads
--- do not use arrowheads if template box is smaller than a half inch space
if ((item 1 of label_w as number) * 72 / unit_maker) > 35 then
	arrow(c1 - 9, -14, c1, -18, c1 - 9, -22)
	arrow(a1 + 9, -14, a1, -18, a1 + 9, -22)
end if

tell application "Adobe Illustrator"
	-- SET SOME TYPE
	set x to (count of characters of label_h) + 8
	if label_h ends with ".0" then set label_h to (label_h as integer) as text
	if doc_units = "inches" then
		set textRef to make new Çclass cTXaÈ in document 1 Â
			with properties {contents:("CUTOFF " & label_h as text) & unit_label, Çclass paPsÈ:{(-72 / 2 - x * 2.5), (b1 / 2 - x)}}
		set rotationMatrix to Çevent ARTxgeRMÈ given Çclass pAGLÈ:-90
		Çevent ARTxTRANÈ textRef given Çclass TRmxÈ:rotationMatrix, Çclass pTXxÈ:Çconstant ePRae122È
	else
		set textRef to make new Çclass cTXaÈ in document 1 Â
			with properties {contents:("CUTOFF " & label_h as text) & unit_label, Çclass paPsÈ:{(-72 / 2 - x * 3.5), (b1 / 2 - x)}}
		
		set rotationMatrix to Çevent ARTxgeRMÈ given Çclass pAGLÈ:-90
		Çevent ARTxTRANÈ textRef given Çclass TRmxÈ:rotationMatrix, Çclass pTXxÈ:Çconstant ePRae122È
	end if
	
	if item 1 of label_w ends with ".0" then set item 1 of label_w to (item 1 of label_w as integer) as text
	if ((item 1 of label_w as number) * 72 / unit_maker) > 10 then
		set textRef2 to make new Çclass cTXaÈ in document 1 Â
			with properties {contents:(item 1 of label_w as text) & unit_label, Çclass paPsÈ:{(c1 / 2), (-72 / 2) + 14}}
	else
		set textRef2 to make new Çclass cTXaÈ in document 1 Â
			with properties {contents:(item 1 of label_w as text) & unit_label, Çclass paPsÈ:{(c1 / 2), (-72 / 2) + 7}}
	end if
	
	set shortie to 7 as number
end tell

repeat with i from 2 to the_count
	--set shortie to shortie * -1
	
	set x to i - 1
	set a1 to a1 + ((item x of label_w as number) * 72 / unit_maker)
	set b1 to (label_h as number) * 72 / unit_maker
	set c1 to c1 + ((item i of label_w as number) * 72 / unit_maker)
	set d1 to 0
	--make new rectangle
	box(a1, b1, c1, d1)
	--- LOWER DIM LIN
	crop(a1, -18, c1, -18)
	crop(c1, -9, c1, -27)
	
	---- Lower line arrowheads
	-- no arrowheads under a half inch space
	if ((item i of label_w as number) * 72 / unit_maker) > 35 then
		arrow(c1 - 9, -14, c1, -18, c1 - 9, -22)
		arrow(a1 + 9, -14, a1, -18, a1 + 9, -22)
	end if
	
	tell application "Adobe Illustrator"
		-- lower dimensions if under 1/8 inch space
		if item i of label_w ends with ".0" then set item i of label_w to (item i of label_w as integer) as text
		if ((item i of label_w as number) * 72 / unit_maker) > 10 then
			set textRef2 to make new Çclass cTXaÈ in document 1 Â
				with properties {contents:((item i of label_w) as text) & unit_label, Çclass paPsÈ:{(c1 - (((item i of label_w as number) * 72 / unit_maker) / 2)), (-72 / 2) + 14}}
			
		else
			set textRef2 to make new Çclass cTXaÈ in document 1 Â
				with properties {contents:((item i of label_w) as text) & unit_label, Çclass paPsÈ:{(c1 - (((item i of label_w as number) * 72 / unit_maker) / 2)), (-72 / 2) + (shortie)}}
		end if
	end tell
	
end repeat

-- Total 1up Web lines
crop(0, b1 + 9, 0, b1 + 27)
crop(c1, b1 + 9, c1, b1 + 27)
crop(0, b1 + 18, c1, b1 + 18)

-- web arrowheads
arrow(c1 - 9, b1 + 14, c1, b1 + 18, c1 - 9, b1 + 22)
arrow(0 + 9, b1 + 14, 0, b1 + 18, 0 + 9, b1 + 22)

set noprint_matrix to the text returned of test
set skip_me to the button returned of test

if skip_me = "Skip" then
	-- do nothing
else
	set AppleScript's text item delimiters to " "
	set noprint to text items of noprint_matrix
	set AppleScript's text item delimiters to ""
	
	try
		set b2 to (b1) - 1 * ((item 1 of noprint as number) * 72) / unit_maker
		set d2 to 1 * ((item 2 of noprint as number) * 72) / unit_maker
		set a2 to 1 * ((item 3 of noprint as number) * 72) / unit_maker
		set c2 to (c1) - 1 * ((item 4 of noprint as number) * 72) / unit_maker
	on error errMsg
		display dialog errMsg buttons {"Cancel"} default button 1 with icon 3
	end try
	
	-- No Print Margin Box (can also be used as bleed if using all negative numbers at data entry point)
	
	tell application "Adobe Illustrator"
		make new Çclass shRCÈ at beginning of document 1 Â
			with properties {bounds:{a2, b2, c2, d2}, Çclass aiFPÈ:false, Çclass aiNTÈ:"noprintmargin", Çclass aiDSÈ:{(7.2), (7.2)}}
	end tell
	
	-- Layflat Dimensions (Left half, Right half of Label)
	crop(0, -36, 0, -54)
	crop(c1 / 2, -36, c1 / 2, -54)
	crop(c1, -36, c1, -54)
	crop(0, -45, c1 / 2, -45)
	crop(c1 / 2, -45, c1, -45)
	
	
	--layflat arrowheads 
	arrow(c1 - 9, -41, c1, -45, c1 - 9, -49)
	arrow(9, -41, 0, -45, 9, -49)
	arrow(c1 / 2 - 9, -41, c1 / 2, -45, c1 / 2 - 9, -49)
	arrow(c1 / 2 + 9, -41, c1 / 2, -45, c1 / 2 + 9, -49)
	
	-- layflat text
	tell application "Adobe Illustrator"
		set textRef2 to make new Çclass cTXaÈ in document 1 Â
			with properties {contents:("LAYFLAT " & (doc_half) as text) & unit_label as text, Çclass paPsÈ:{(c1 / 4), -50}}
		
		set textRef2 to make new Çclass cTXaÈ in document 1 Â
			with properties {contents:("LAYFLAT " & (doc_half) as text) & unit_label as text, Çclass paPsÈ:{(c1 / 2 + c1 / 4), -50}}
	end tell
	
end if

tell application "Adobe Illustrator"
	-- web dim amount
	set textRef2 to make new Çclass cTXaÈ in document 1 Â
		with properties {contents:(("WEB " & doc_web) as text) & unit_label, Çclass paPsÈ:{(c1 / 2), 36 + b1}}
	-- try
	-- clean up alignment overprint extra
	tell document 1
		set (Çclass aiFCÈ of every paragraph of every Çclass cTXaÈ) to {Çclass caCCÈ:newSpot, Çclass TINTÈ:100.0}
		set Çclass pT16È of every paragraph of every Çclass cTXaÈ to {Çconstant ePRae122È}
		set (Çclass aiFOÈ of every paragraph of every Çclass cTXaÈ) to true
		set (Çclass aiSOÈ of every Çclass caPAÈ) to true
		set (name of Çclass caLYÈ 1) to "die"
	end tell
	
	-- clear color
	set a1 to 0
	set newlayer to make new Çclass caLYÈ at the end of document 1 with properties {name:"clear"}
	set newSpot to make new Çclass caCCÈ in document 1 with properties Â
		{name:"clear", color:{Çclass CYANÈ:0.0, Çclass MAGNÈ:0.0, Çclass YELLÈ:0.0, Çclass BLAKÈ:20.0}, Çclass paCTÈ:Çconstant eCMde427È}
	make new Çclass shRCÈ at the end of document 1 with properties {Çclass aiSPÈ:false, bounds:{a1, b1, c1, d1}, Çclass aiNTÈ:"clear", Çclass aiFCÈ:{Çclass caCCÈ:newSpot, Çclass TINTÈ:100.0}}
	--end try
end tell