on open theFiles
	repeat with theFile in theFiles
		set posixPath to POSIX path of theFile
		set theDir to do shell script "dirname " & quoted form of posixPath
		set runCmd to "/bin/bash -c " & quoted form of ("\"" & posixPath & "\" ; echo ; read -n 1 -s -p \"Press any key or Ctrl+C to close...\"")
		
		set hasTmux to do shell script "grep -qE '\\btmux\\b' " & quoted form of posixPath & "; echo $?"
		
		set exportPath to "export PATH=\"$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:$PATH\" && "
		
		if hasTmux is "0" then
			set cmd to exportPath & "cd " & quoted form of theDir & " && " & runCmd
		else
			set cmd to exportPath & "cd " & quoted form of theDir & " && tmux new-window -c " & quoted form of theDir & " " & quoted form of runCmd & " || tmux new-session -d -c " & quoted form of theDir & " " & quoted form of runCmd & " \\; attach-session"
		end if
		
		do shell script "open -n -a \"Alacritty\" --args -e sh -c " & quoted form of cmd
	end repeat
end open

on run
	display dialog "Drop .sh or .command files here to run them in tmux via Alacritty."
end run
