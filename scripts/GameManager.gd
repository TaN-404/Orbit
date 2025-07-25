extends Node

var app_menu_active = false
var settings_active = false
var sticky_notes_active = false

"""QM FLAGS"""
var am_edit = false
var ws_edit = false

"""SETTING FLAGS"""
var on_top = false
var startup = false

"""AppList"""
var app_list_standalone : bool
var applist_pos : Vector2

"""Windows"""
var menu_window : Window
var settings_window : Window

"""Animation Flags"""
enum AnimationType {
	BlackHole,
	GasGiant,
	Star,
	DryPlanet
}

var current_animation : AnimationType


const FIRST_RUN = "user://config_files/first_run.cfg"
const SETTINGS = "user://config_files/settings.cfg"

 
var config = ConfigFile.new()

func _ready() -> void:
	load_settings()
	# This _ready() function runs very early, before your main scene's _ready().
	
	#var error = config.load(FIRST_RUN)
#
	#if error != OK:
		## File doesn't exist or couldn't be loaded, meaning it's the first run
		#print("First time running the app!")
		#run_first_time_setup()
		#
		## Save the flag so it's not considered a first run next time
		#config.set_value("app_state", "has_run_before", true)
		#config.save(FIRST_RUN)
	#else:
	## File exists and loaded successfully, check the flag
		#var has_run_before = config.get_value("app_state", "has_run_before", false)
		#if not has_run_before:
			## This case might happen if the file was created but the flag wasn't set (e.g., app crashed)
			#print("First time running the app (flag not set)!")
			#run_first_time_setup()
			#config.set_value("app_state", "has_run_before", true)
			#config.save(FIRST_RUN)
		#else:
			#print("App has been run before.")
			## Normal startup logic if not the first time
			#load_user_preferences()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.

func load_settings():
	var error = config.load(SETTINGS)
	if error != OK:
		# File doesn't exist or couldn't be loaded, create default settings
		print("Settings file not found or error loading, creating default settings.")
		save_settings() # Save defaults immediately
		return

	on_top = config.get_value("App", "always_on_top", false)
	startup = config.get_value("App", "startup", false)
	current_animation = config.get_value("AnimationType", "Index", 0)



func save_settings():
	# Save the checkbutton state
	# Save other settings
	config.set_value("AnimationType", "Index", current_animation)
	config.set_value("App", "always_on_top", on_top)
	config.set_value("App", "startup", startup)

	config.save(SETTINGS)
	print("Settings saved.")

func _process(delta: float) -> void:
	pass


func run_first_time_setup():
	pass

func load_user_preferences():
	pass

func always_on_top(window : Window, booelan : bool):
	window.always_on_top = booelan
	
	
func convert_spelled_number_to_digit(text: String) -> String:
	"""
	Converts common spelled-out numbers (zero to ninety-nine, and some hundreds/thousands)
	in a string to their digit equivalents.
	Note: This is a simple word-for-word replacement.
	It does NOT handle complex number parsing like "one hundred and twenty-three".
	"""
	var number_map = {
		# Single digits
		"zero": "0", "one": "1", "two": "2", "three": "3", "four": "4",
		"five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9",
		
		# Teens
		"ten": "10", "eleven": "11", "twelve": "12", "thirteen": "13", 
		"fourteen": "14", "fifteen": "15", "sixteen": "16", 
		"seventeen": "17", "eighteen": "18", "nineteen": "19",
		
		# Tens
		"twenty": "20", "thirty": "30", "forty": "40", "fifty": "50", 
		"sixty": "60", "seventy": "70", "eighty": "80", "ninety": "90",
		
		# Higher magnitudes (handle with care, as they often combine)
		# For simplicity, these are just direct replacements.
		# "hundred": "100",
		# "thousand": "1000",
		# "million": "1000000"
	}

	var words: PackedStringArray = text.split(" ")
	var converted_words: PackedStringArray = []
	
	for word in words:
		var lower_word = word.to_lower()
		if number_map.has(lower_word):
			converted_words.append(number_map[lower_word])
		else:
			converted_words.append(word)
			
	return " ".join(converted_words)


func _exit_tree() -> void:
	save_settings()
