# CommandManager.gd (Autoload/Singleton)
extends Node


"""EXE"""
const VOLUME_EXE = "res://bin/volume.exe"


var message_number = 0
var message
var last_text = ""

signal command_recognized(command_name, arguments)

# Dictionary to store commands and their associated data (e.g., regex, function name)
var commands = {
	"open_app": {
		"patterns": ["open (.+)", "launch (.+)"], # Regex patterns for flexibility
		"action_method": "_on_open_app_command"
	},
	"close_app": {
		"patterns": ["close (.+)", "quit (.+)"],
		"action_method": "_on_close_app_command"
	},
	"search_web": {
		"patterns": ["search for (.+)", "find (.+) on the web", "look for (.+)"],
		"action_method": "_on_search_web_command"
	},
	"set_volume": {
		"patterns": ["set volume to (.+)", "volume (.+)", "change volume to (.+)"],
		"action_method": "_on_set_volume_command"
	},
	# Add more commands here
	"show_time": {
		"patterns": ["what time is it", "tell me the time"],
		"action_method": "_on_show_time_command"
	},
	"goodbye": {
		"patterns": ["goodbye", "see you later"],
		"action_method": "_on_goodbye_command"
	},
	"system prank":{
		"patterns":["delete system", "delete system 32", "delete system thirty two"],
		"action_method": "_on_system_prank"
	}
}

func _process(delta: float) -> void:
	
	if SpeechListener.voice_mode:
		if SpeechListener.listener_ready: 
			message = SpeechListener.get_latest_speech()
			if message["Number"] > message_number:
				last_text = message["Message"]
				process_speech_input(last_text)
				message_number += 1
	


# --- Core Command Processing Function ---
func process_speech_input(input_text: String):
	var lower_input = input_text.to_lower()
	print("Processing input: '{lower_input}'")

	for command_name in commands:
		var command_data = commands[command_name]
		for pattern_str in command_data["patterns"]:
			var regex = RegEx.new()
			# Compile the regex. Ensure it's case-insensitive if needed.
			regex.compile(pattern_str)

			var match = regex.search(lower_input)

			if match:
				var arguments = []
				# Extract arguments from regex groups
				for i in range(1, match.get_group_count() + 1):
					arguments.append(match.get_string(i))
				
				# Emit a signal that other parts of your app can connect to
				emit_signal("command_recognized", command_name, arguments)

				# Directly call the action method (alternative to signals, or use both)
				if has_method(command_data["action_method"]):
					callv(command_data["action_method"], arguments)
				else:
					printerr("Error: Action method '{command_data['action_method']}' not found for command '{command_name}'")
				
				return # Stop after finding the first match

	print("No command recognized for: ", input_text)
	# Emit a signal for "no command found" or play a "didn't understand" sound
	emit_signal("command_recognized", "no_command", [])


# --- Action Methods (where the magic happens) ---
# These methods will contain the logic for each command.

func _on_open_app_command(app_name: String):
	# This will use your existing app list logic
	if app_name.begins_with("workspace"):
		#var app_array = [] 
		app_name = GameManager.convert_spelled_number_to_digit(app_name)
	if WorkspaceManager.config_data.has(app_name):
		for apps in WorkspaceManager.config_data[app_name]:
			var paths = WorkspaceManager.config_data[app_name][apps]["app_path"]
			var app = WorkspaceManager.config_data[app_name][apps]["app_name"] # This 'app' variable is the issue

			if AppManager.workspace_pids.has(app_name):
				print("Does AppManager.workspace_pids['{app_name}'] have '{app}'? {AppManager.workspace_pids[app_name].has(app)}")
			
			if not AppManager.workspace_pids.has(app_name):
				AppManager.workspace_pids[app_name] = {}
			if not AppManager.workspace_pids[app_name].has(app):
				AppManager.workspace_pids[app_name][app] = {}
			
			var pid = AppManager.open_app(paths)
			
			# This is the line that's failing:
			AppManager.workspace_pids[app_name][app]["pid"] = pid # <-- Error here
		#AppManager.open_multiple_app(app_array)
		
	else:
		print("Action: Attempting to open app: {app_name}")
		if AppManager.configured_apps_data.has(app_name):
			var exe = AppManager.configured_apps_data[app_name]["exe_path"]
			if not AppManager.normal_pids.has(app_name):
				AppManager.normal_pids[app_name] = {}
				
			var pid = AppManager.open_app(exe)
			AppManager.normal_pids[app_name]["pid"] = pid
		else:
			print(app_name, "not found")
	#print(app_name)
	#get_node("/root/YourMainSceneNode").launch_app_by_name(app_name)


func _on_close_app_command(app_name: String):
	if app_name.begins_with("workspace"):
		app_name = GameManager.convert_spelled_number_to_digit(app_name)
		if AppManager.workspace_pids.has(app_name):
			for app in AppManager.workspace_pids[app_name]:
				var exe_name = app + ".exe"
				var pid = AppManager.get_all_pids_by_exe_name(exe_name)
				for id in pid:
					AppManager.kill_process(id)

	else:
		if AppManager.normal_pids.has(app_name):
			var exe_name = app_name + ".exe"
			var pid = AppManager.get_all_pids_by_exe_name(exe_name)
			print(app_name, pid)
			for id in pid:
				AppManager.kill_process(id)


func _on_search_web_command(query: String):
	print("Action: Searching the web for: {query}")
	var url_encoded_query = query.uri_encode()
	var link = "https://www.google.com/search?q=" + url_encoded_query
	# Use OS.shell_open() to open the default web browser
	OS.shell_open(link)


func _on_set_volume_command(value_str: String):
	print("Action: Setting volume to: {value_str}")
	#print(value_str)
	value_str = GameManager.convert_spelled_number_to_digit(value_str)
	var volume_exe = ProjectSettings.globalize_path(VOLUME_EXE)
	var arguments = [
		value_str
	]
	var exit_code = OS.execute(volume_exe, arguments)
	if exit_code == 0:
		print("volume set to", value_str)
	else :
		print("Error")


func _on_show_time_command():
	var current_time = Time.get_time_string_from_system()
	print("Action: The current time is: {current_time}")
	# You could also trigger a TTS (Text-to-Speech) to speak this aloud.
	# Example TTS (conceptual, requires external library or API):
	# TextToSpeechManager.speak(f"The current time is {current_time}")
	
func _on_system_prank():
	print("________________prank________________")


func _on_goodbye_command():
	print("Action: Goodbye!")
	get_tree().quit() # Quits the application
