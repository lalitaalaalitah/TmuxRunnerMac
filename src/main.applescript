on open theFiles
	repeat with theFile in theFiles
		set posixPath to POSIX path of theFile
		set theDir to do shell script "dirname " & quoted form of posixPath
		set cmd to "cd " & quoted form of theDir & " && /run/current-system/sw/bin/tmux new-window -c " & quoted form of theDir & " " & quoted form of posixPath & " \\; set-option remain-on-exit on || /run/current-system/sw/bin/tmux new-session -d -c " & quoted form of theDir & " " & quoted form of posixPath & " \\; set-option remain-on-exit on \\; attach-session"
		do shell script "open -n -a \"Alacritty\" --args -e sh -c " & quoted form of (cmd & " ; read -p \"Press Enter to exit\"")
	end repeat
end open

on run
	display dialog "Drop .sh or .command files here to run them in tmux via Alacritty."
end run
