-- 2017 High Scores over 10k:
-- #1   14993  -  10.16.17  2:57:13 PM
-- #2   14436  -  10.23.17  2:57:13 PM
-- #3   13399  -  10.17.17  2:52:03 PM
-- #4   13341  -  10.02.17  3:40:21 PM
-- #5   13296  -  10.10.17  2:38:32 PM
-- #6   12854  -  10.03.17  2:57:39 PM
-- #7   12676  -  10.18.17  2:52:38 PM
-- #8   12207  -  10.11.17  3:30:10 PM
-- #9   11989  -  10.09.17  4:02:00 PM
-- #10 11803  -  10.04.17  3:17:54 PM
-- #11 11676  -  10.12.17  4:38:55 PM
-- #12 11355  -  10.05.17  3:44:06 PM
-- #13 11205  -  09.25.17  3:57:43 PM
-- #14 10662  -  09.26.17  3:52:17 PM
-- #15 10646  -  09.18.17  4:31:00 PM
-- #16 10464  -  09.27.17  2:46:22 PM

-- 2016 High Scores over 10k:
-- #1  12481  -  10.24.16  2:44:49 PM
-- #2  10944  -  10.11.16  3:27:53 PM

property todayshigh : 500

property highscore : 14993 -- <-- 2017's high

property currentscore : 0
set cellphone to "7046419300"
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
						-- Text Todd's Cell Phone
						do shell script "curl url http://textbelt.com/text -d number=" & cellphone & " -d message=" & quoted form of ("Record High: " & highscore & "  -  " & currentDate)
					end try *)
					
					set throttle to 0.1
				end if
				
			end try
			
		end repeat
		
	end tell
end tell

get stat