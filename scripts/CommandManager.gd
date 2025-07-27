# CommandManager.gd (Autoload/Singleton)
extends Node


"""EXE"""
const VOLUME_EXE = "res://bin/volume.exe"


var message_number = 0
var message
var last_text = ""

# --- New: Wake Word State Variable ---
var waiting_for_wake_word = true # Start in wake word listening mode
var command_listening_timer: Timer = null # Timer for command listening window

# --- Customizable Settings ---
const WAKE_WORD_LISTENING_DURATION = 5.0 # How long to listen for commands after wake word (seconds)
const WAKE_WORD_CONFIRMATION_PHRASE = "Yes, how can I help?" # What Orbit says after wake word

signal command_recognized(command_name, arguments)
signal assistant_state_changed(is_active: bool) # To notify UI or other systems


# Dictionary to store commands and their associated data (e.g., regex, function name)
var commands = {
	# --- New: Wake Word Command ---
	"wake_word_activate": {
		"patterns": [
			"orbit",
			"hey orbit",
			"good morning orbit",
			"hello orbit",
			"hi orbit",
			"orbit",
			"good evening orbit",
			"good afternoon orbit"
		],
		"action_method": "_on_wake_word_activated",
		"is_wake_word": true # Mark this command as a wake word
	},
	# --- Existing Commands (No changes needed here) ---
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
	"show_time": {
		"patterns": ["what time is it", "tell me the time"],
		"action_method": "_on_show_time_command"
	},
	"goodbye": {
		"patterns": ["goodbye", "see you later"],
		"action_method": "_on_goodbye_command"
	},
	"system_prank":{ # Renamed to snake_case for consistency
		"patterns":["delete system", "delete system 32", "delete system thirty two"],
		"action_method": "_on_system_prank"
	}
}

func _ready() -> void:
	# Initialize the timer
	command_listening_timer = Timer.new()
	add_child(command_listening_timer)
	command_listening_timer.one_shot = true
	command_listening_timer.connect("timeout", Callable(self, "_on_command_listening_timeout"))
	
	# Initial state broadcast
	emit_signal("assistant_state_changed", !waiting_for_wake_word)


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
			regex.compile(pattern_str)

			var match = regex.search(lower_input)

			if match:
				# --- New: Wake Word Logic ---
				if command_data.has("is_wake_word") and command_data["is_wake_word"]:
					if waiting_for_wake_word:
						print("Wake word recognized: '{input_text}'")
						_on_wake_word_activated()
						return # Stop processing, as wake word is found
					else:
						# If wake word is spoken while already active, ignore it or reset timer
						print("Wake word spoken while already active. Resetting timer.")
						_start_command_listening_timer() # Reset the timer
						return

				# --- Original Command Logic (only if not waiting for wake word) ---
				if not waiting_for_wake_word:
					var arguments = []
					for i in range(1, match.get_group_count() + 1):
						arguments.append(match.get_string(i))

					emit_signal("command_recognized", command_name, arguments)

					if has_method(command_data["action_method"]):
						callv(command_data["action_method"], arguments)
						# After a command, you might want to reset the listening timer
						_start_command_listening_timer()
					else:
						printerr("Error: Action method '{command_data['action_method']}' not found for command '{command_name}'")
					
					return # Stop after finding the first match
				else:
					# If we are waiting for a wake word and a non-wake word command is spoken, ignore it
					print("Ignoring command '{command_name}' as we are waiting for a wake word.")
					return # Do not process further in this loop

	# --- New: Handle "No command recognized" based on state ---
	if not waiting_for_wake_word:
		print("No command recognized for: ", input_text)
		emit_signal("command_recognized", "no_command", [])
		# If no command is found, you might want to reset the listening timer as well
		_start_command_listening_timer()
	else:
		print("Not in command listening mode. Ignoring input: ", input_text)


# --- New: Wake Word Action Method ---
func _on_wake_word_activated():
	if waiting_for_wake_word:
		waiting_for_wake_word = false
		print("Assistant is now listening for commands!")
		emit_signal("assistant_state_changed", true) # Broadcast activation
		# You can add a Text-to-Speech response here, e.g.:
		# TextToSpeechManager.speak(WAKE_WORD_CONFIRMATION_PHRASE)
		_start_command_listening_timer() # Start the timer for command listening

# --- New: Timer Management Functions ---
func _start_command_listening_timer():
	command_listening_timer.start(WAKE_WORD_LISTENING_DURATION)
	print("Command listening timer started for", WAKE_WORD_LISTENING_DURATION, "seconds.")

func _on_command_listening_timeout():
	if !waiting_for_wake_word: # Only deactivate if we were active
		waiting_for_wake_word = true
		print("Command listening window timed out. Returning to wake word listening mode.")
		emit_signal("assistant_state_changed", false) # Broadcast deactivation
		# You might add a sound effect here to indicate it's no longer listening


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
	# IMPORTANT: For a real prank, ensure you are NOT actually deleting system files.
	# This should just be a simulated message or a harmless action.
	# E.g., play a scary sound, display a fake error message.


func _on_goodbye_command():
	print("Action: Goodbye!")
	get_tree().quit() # Quits the application
