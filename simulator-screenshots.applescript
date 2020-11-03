--screenshots via AppleScript
set a to 2
set b to 5
property simulator : "Simulator" --"SimulatorTrampoline.xpc" //recommend using Simulator


on t(d)
	delay d
	if application simulator is frontmost then
		tell application "System Events"
			keystroke "s" using command down
		end tell
	end if
end t

on s(a, b)
	
	t(a)
	
	repeat
		t(b)
	end repeat
	
end s

s(a, b)
