# CommandManager.gd
extends Node

var commands = {}

func _ready():
	register_command("open browser", open_browser)
	register_command("what time is it", tell_time)
	register_command("play music", play_music)

func register_command(trigger: String, callback: Callable) -> void:
	commands[trigger.to_lower()] = callback

func handle_command(input: String):
	var normalized_input = input.strip_edges().to_lower()
	for trigger in commands.keys():
		if normalized_input.begins_with(trigger):
			commands[trigger].call()
			return
	print("Unknown command:", input)

# Examples of callbacks
func open_browser():
	print("Opening browser...")
	OS.shell_open("https://www.google.com")

func tell_time():
	var now = Time.get_time_dict_from_system()
	print("Current time is %02d:%02d" % [now["hour"], now["minute"]])

func play_music():
	print("Playing music...")
