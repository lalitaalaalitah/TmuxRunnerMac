on open theFiles
	repeat with theFile in theFiles
		set posixPath to POSIX path of theFile
		set theDir to do shell script "dirname " & quoted form of posixPath
		set runCmd to "/bin/bash -c " & quoted form of ("\"" & posixPath & "\" ; echo ; read -n 1 -s -p \"Press any key or Ctrl+C to close...\"")
		set cmd to "cd " & quoted form of theDir & " && /run/current-system/sw/bin/tmux new-window -c " & quoted form of theDir & " " & quoted form of runCmd & " || /run/current-system/sw/bin/tmux new-session -d -c " & quoted form of theDir & " " & quoted form of runCmd & " \\; attach-session"
		do shell script "open -n -a \"Alacritty\" --args -e sh -c " & quoted form of cmd
	end repeat
end open

on run
	display dialog "Drop .sh or .command files here to run them in tmux via Alacritty."
end run
