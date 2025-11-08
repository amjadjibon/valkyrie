# VHS documentation
#
# Output:
#   Output <path>.gif               Create a GIF output at the given <path>
#   Output <path>.mp4               Create an MP4 output at the given <path>
#   Output <path>.webm              Create a WebM output at the given <path>
#
# Require:
#   Require <string>                Ensure a program is on the $PATH to proceed
#
# Settings:
#   Set FontSize <number>           Set the font size of the terminal
#   Set FontFamily <string>         Set the font family of the terminal
#   Set Height <number>             Set the height of the terminal
#   Set Width <number>              Set the width of the terminal
#   Set LetterSpacing <float>       Set the letter spacing of the terminal
#   Set LineHeight <float>          Set the line height of the terminal
#   Set LoopOffset <float>%         Set the starting frame offset for the GIF loop
#   Set Theme <json|string>         Set the theme of the terminal
#   Set Padding <number>            Set the padding of the terminal
#   Set Framerate <number>          Set the framerate of the recording
#   Set PlaybackSpeed <float>       Set the playback speed of the recording
#
# Sleep:
#   Sleep <time>                    Sleep for a set amount of <time> in seconds
#
# Type:
#   Type[@<time>] "<characters>"    Type <characters> into the terminal with a
#                                   <time> delay between each character
#
# Keys:
#   Backspace[@<time>] [number]     Press the Backspace key
#   Down[@<time>] [number]          Press the Down key
#   Enter[@<time>] [number]         Press the Enter key
#   Space[@<time>] [number]         Press the Space key
#   Tab[@<time>] [number]           Press the Tab key
#   Left[@<time>] [number]          Press the Left Arrow key
#   Right[@<time>] [number]         Press the Right Arrow key
#   Up[@<time>] [number]            Press the Up Arrow key
#   Down[@<time>] [number]          Press the Down Arrow key
#   Ctrl+<key>                      Press the Control key + <key> (e.g. Ctrl+C)
#
# Display:
#   Hide                            Hide the subsequent commands from the output
#   Show                            Show the subsequent commands in the output

Output demo.gif

Require echo

Set Shell "bash"
Set FontSize 14
Set Width 1200
Set Height 600
Set Padding 20
Set Framerate 30
Set PlaybackSpeed 1.0

# Build the example first
Hide
Type "make build-example > /dev/null 2>&1 && clear"
Enter
Sleep 1s
Show

# Title
Type "# Valkyrie CLI Framework Demo"
Sleep 1s
Enter
Enter

# Show help
Type "./build/mycli --help"
Sleep 500ms
Enter
Sleep 3s

# Greet command
Type "./build/mycli greet --name Alice"
Sleep 500ms
Enter
Sleep 2s

# Greet with count
Type "./build/mycli greet --name Bob --count 3"
Sleep 500ms
Enter
Sleep 2s

# Greet in uppercase
Type "./build/mycli greet -n Charlie -c 2 -u"
Sleep 500ms
Enter
Sleep 2s

# Math add command
Type "./build/mycli math add --a 15 --b 27"
Sleep 500ms
Enter
Sleep 2s

# Math multiply command
Type "./build/mycli math multiply --x 3.5 --y 2.8"
Sleep 500ms
Enter
Sleep 2s

# List command
Type "./build/mycli list"
Sleep 500ms
Enter
Sleep 2s

# List with filter
Type "./build/mycli list --filter berry"
Sleep 500ms
Enter
Sleep 2s

# List with verbose
Type "./build/mycli list -v -f apple"
Sleep 500ms
Enter
Sleep 2s

# Server info
Type "./build/mycli server info"
Sleep 500ms
Enter
Sleep 2s

# Server start
Type "./build/mycli server start --port 3000 --daemon"
Sleep 500ms
Enter
Sleep 2s

# Show help for a subcommand
Type "./build/mycli math --help"
Sleep 500ms
Enter
Sleep 3s

# Final message
Enter
Type "# Built with Valkyrie ⚔️"
Sleep 3s
