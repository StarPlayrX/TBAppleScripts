(**
 * scrape-google-analytics-AS by Todd Bruss
 * Safari Browser, Google Analytics WebPage
 * AppleScript and JavaScript Engine
 * Requires: Allow JavaScript from Apple Events
 * in Safari and needs to be set with a wired keyboard
 * or via an AppleScript that  does the clicks
 * (off) Update: reloads page at startup and  every hour
 * (c) 2016-2020 Todd Bruss
**)

-- uses AppleScript Only
-- to receive page data in realtime

property todayshigh : 500

property highscore : 14993 -- <-- 2017's high

property currentscore : 0
set cellphone to "7048675309"
set unbreakable to 50000
set throttle to 5
tell application "System Events"
	tell application process "Safari"
		log "Previous Record: " & highscore
		
		repeat until highscore > unbreakable
			delay throttle
			try
				set stat to click at {450, 420}
				
				try
					--set stat to static text 1 of group 1 of group 2 of group 12 of UI element 1 of scroll area 1 of group 1 of group 1 of tab group 1 of splitter group 1 of window 1
					set stat to static text 1 of group 1 of group 2 of group 3 of UI element 1 of scroll area 2 of UI element 1 of scroll area 1 of group 1 of group 1 of tab group 1 of splitter group 1 of window 1
				on error
					log "reloading page..."
					set stat to click at {550, 360}
				end try
				
				set currentscore to name of stat as integer
				
				--log currentscore
				
				set throttle to 3 -- throttle there is no movement
				
				if currentscore > todayshigh then
					set todayshigh to currentscore
					
					set today to get current date
					set myMonth to month of today as integer
					set myDay to day of today
					set myYear to year of today
					set myTime to time string of today
					set currentDate to (myMonth & "." & myDay & "." & myYear & " " & myTime) as string
					
					set myWeekDay to weekday of the (current date) as string
					
					
					log myWeekDay & "'s Best: " & currentscore & "  -  " & currentDate
					set throttle to 1
				else
					set throttle to 2
				end if
				
				if currentscore > highscore then
					set highscore to currentscore
					log "Record High:" & highscore
					set today to get current date
					set myMonth to month of today as integer
					set myDay to day of today
					set myYear to year of today
					set myTime to time string of today
					set currentDate to (myMonth & "." & myDay & "." & myYear & " " & myTime) as string
					
					(*try
						-- This method no longer works
						-- Text Cell Phone
						do shell script "curl url http://textbelt.com/text -d number=" & cellphone & " -d message=" & quoted form of ("Record High: " & highscore & "  -  " & currentDate)
					end try *)
					
					set throttle to 0.1
				end if
				
			end try
			
		end repeat
		
	end tell
end tell

get stat