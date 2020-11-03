(**
 * scrape-google-analytics-JS by Todd Bruss
 * Safari Browser, Google Analytics WebPage
 * AppleScript and JavaScript Engine
 * Requires: Allow JavaScript from Apple Events
 * in Safari and needs to be set with a wired keyboard
 * or via an AppleScript that  does the clicks
 * (off) Update: reloads page at startup and  every hour
 * (c) 2016-2020 Todd Bruss
**)

-- uses JavaScript
-- to receive page data in realtime
property safari : "Safari"

property highscore : 16000
property thisyearshigh : 16000
property currentscore : 16000

set todayshigh to 1500

set newdate to current date
set increment to 5
set closepage to 5
set futuredate to newdate + increment
set closedate to newdate + closepage

set throttle to 5

set closeslideout to false
tell application "Safari"
	tell document 1
		log "This year's high: " & thisyearshigh
		log "Previous Record: " & highscore
		
		repeat
			
			--check if safari should be reloaded
			set newdate to current date
			
			-- reload safari here
			-- turned off for home use
			(**if newdate > futuredate then
				set increment to 3600
				set closepage to 5
				set futuredate to newdate + increment
				set closedate to newdate + closepage
				-- get current URL
				set docUrl to URL
				-- reload current URL
				set URL to docUrl
				set closeslideout to true
			end if
			
			--close slide out
			if closeslideout then
				if (newdate > closedate) then
					set closeslideout to false
					tell application "System Events"
						tell application process safari
							click at {230, 1050}
						end tell
					end tell
				end if
			end if**)
			
			delay throttle
			try
				do JavaScript "var iframe = document.getElementById('galaxyIframe');"
				do JavaScript "var innerDoc = iframe.contentDocument;"
				
				
				do JavaScript "var counterValue = innerDoc.getElementById('ID-overviewCounterValue');"
				
				set currentscore to do JavaScript "counterValue.textContent;"
				--log currentscore
				set currentscore to currentscore + 0 --ensures we have a number
				
				set throttle to 3 -- throttle there is no movement
				
				if currentscore > todayshigh then
					set todayshigh to currentscore
					
					tell application "Finder"
						set today to get current date
					end tell
					set myMonth to month of today as integer
					set myDay to day of today
					set myYear to year of today
					set myTime to time string of today
					set currentdate to (myMonth & "." & myDay & "." & myYear & " " & myTime) as string
					
					set myWeekDay to weekday of the (today) as string
					
					
					log myWeekDay & "'s Best: " & currentscore & "  -  " & currentdate
					set throttle to 1
				else
					set throttle to 2
				end if
				
				if currentscore > highscore then
					set highscore to currentscore
					log "Record High:" & highscore
					--set today to get current date
					set myMonth to month of today as integer
					set myDay to day of today
					set myYear to year of today
					set myTime to time string of today
					set currentdate to (myMonth & "." & myDay & "." & myYear & " " & myTime) as string
					
					set throttle to 0.1
				end if
				
			end try
			
		end repeat
	end tell
	
end tell
q