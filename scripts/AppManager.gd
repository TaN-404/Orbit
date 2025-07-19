#extends Node
#
#
#"""CFG PATHS"""
#const APP_CONFIG_PATH = "user://app_menu.cfg"
#const WORKSPACE_CONFIG_PATH = "user://workspace.cfg"
#
#"""DICTIONARIES"""
#var workspace_dictionary = {}
#var button_dictionary = {}
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#initialize_buttons()
	#load_apps()
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#for button_name in button_dictionary:
		#var button_data = button_dictionary[button_name]
		##print(button_data)
	#pass
#
#func initialize_buttons():
	## Clear existing dictionary
	#button_dictionary.clear()
##
	## Add all 8 buttons with default values
	#for i in range(1, 9):
		#var button_name = "App%d" % i
		#button_dictionary[button_name] = {
			#"exe_path": "",
			#"exe_icon": ""
		#}
		#
#
#func save_apps():
	#var config = ConfigFile.new()
	#
	## Save each button's data under its own section
	#for button_name in button_dictionary:
		#var button_data = button_dictionary[button_name]
		#config.set_value(button_name, "exe_path", button_data["exe_path"])
		#config.set_value(button_name, "exe_icon", button_data["exe_icon"])
	#
	#if config.save(APP_CONFIG_PATH) != OK:
		#push_error("Failed to save button data")
	#else:
		#print("All buttons saved successfully")
		#
	#
	#
#func update_button(button_name: String, exe_path: String, exe_icon: String):
	#if button_name in button_dictionary:
		#button_dictionary[button_name]["exe_path"] = exe_path
		#button_dictionary[button_name]["exe_icon"] = exe_icon
		#save_apps()
	#else:
		#push_error("Button %s not found" % button_name)
		#
		#
#func remove_button(button_name : String):
	#if button_name in button_dictionary:
		#button_dictionary[button_name]["exe_path"] = ""
		#button_dictionary[button_name]["exe_icon"] = ""
		#save_apps()
	#else:
		#push_error("Button %s not found" % button_name)
	#
	#
#func update_icon(button: Button, icon: String):
	#if FileAccess.file_exists(icon):
		#var tex = load(icon)
		#if tex and tex is Texture2D:
			#var image = tex.get_image()
			#if image:
				#image.resize(40, 40, Image.INTERPOLATE_LANCZOS)
				#var scaled_tex = ImageTexture.create_from_image(image)
				#button.icon = scaled_tex
			#else:
				#print("❌ Failed to get image from texture:", icon)
		#else:
			#print("❌ Failed to load valid texture:", icon)
	#else:
		#print("⚠️ Icon file not found:", icon)
		#button.icon = preload("res://assets/icons/40x40/alert-square-Stroke-Rounded.png")
#
		#
#func remove_icon(button : Button):
	#button.icon = preload("res://assets/icons/40x40/add-01-Stroke-Rounded.png")
	##pass
#
#
#func load_apps() :
	#var config = ConfigFile.new()
#
#
	#if config.load(APP_CONFIG_PATH) != OK:
		#print("No saved button data found, using defaults")
		##initialize_buttons()
		#return
	#
	## Load each button that exists in the config
	#for button_name in config.get_sections():
		#if button_name.begins_with("App"):  # "ButtonX"
			#button_dictionary[button_name] = {
				#"exe_path": config.get_value(button_name, "exe_path", ""),
				#"exe_icon": config.get_value(button_name, "exe_icon", "")
			#}
	#
	## Ensure all 8 buttons exist (in case config was incomplete)
	##for i in range(1, 9):
		##var button_name = "Button%d" % i
		##if not button_name in button_dictionary:
			##button_dictionary[button_name] = {"exe_path": "", "exe_icon": ""}
			#
			#
			#
#func open_app(exe_path):
	#if OS.has_feature("windows"):
		#var args = []
		#var output = OS.execute_with_pipe(exe_path,args)   ### ths function is new to godot 4.3 and 4.4 and is not available in lower versions ###
		#var process_id = output["pid"]
		#return process_id
		#
		#


extends Node

const BASE_PATH := "res://bin/"
const GAME_DATA_PATH = "user://config_files"
const APPS_CONFIG_PATH = "user://config_files/app_menu.cfg"
const FILTERED_APPS_JSON_PATH = "res://bin/filtered_apps.json"

# --- Constants for App Attribute Keys ---
const APP_ATTR_EXE_PATH = "exe_path"
const APP_ATTR_ICON_PATH = "icon_path"
const APP_ATTR_CATEGORY = "category"
const APP_ATTR_WORKSPACES = "workspaces"
const APP_ATTR_QUICK_MENU_SLOT = "quick_menu_slot"

var configured_apps_data = {}

func _ready() -> void:
	check_and_create_directories()
	load_app_configurations()
	import_filtered_filtered_apps_from_json()
	#print(configured_apps_data)
	#test()
	

func check_and_create_directories() -> void:
	var dir = DirAccess.open("user://")
	if dir:
		# Check and create game_data directory
		if not dir.dir_exists("config_files"):
			dir.make_dir("config_files")
			print("Created directory: config_files")
			
func load_app_configurations():
	var config = ConfigFile.new()
	var error = config.load(APPS_CONFIG_PATH)

	if error == OK:
		var sections = config.get_sections()
		for app_name in sections:
			var app_data = {}
			app_data["exe_path"] = config.get_value(app_name, "exe_path", "")
			app_data["icon_path"] = config.get_value(app_name, "icon_path", "")
			app_data["category"] = config.get_value(app_name, "category", "Uncategorized")

			var workspaces_str = config.get_value(app_name, "workspaces", "")
			app_data["workspaces"] = []
			if not workspaces_str.is_empty():
				for ws_id_str in workspaces_str.split(",", false):
					var ws_id = ws_id_str.strip_edges().to_int()
					if ws_id > 0:
						app_data["workspaces"].append(ws_id)
			
			app_data["quick_menu_slot"] = config.get_value(app_name, "quick_menu_slot", -1)

			configured_apps_data[app_name] = app_data
		print("Existing app configurations loaded from:", APPS_CONFIG_PATH)
	else:
		push_warning("Could not load existing app configuration file: ", APPS_CONFIG_PATH, " Error: ", error)
		# Initialize with empty data if file doesn't exist or error
		configured_apps_data = {}

func save_app_configurations():
	var config = ConfigFile.new()
	for app_name in configured_apps_data.keys():
		var app_data = configured_apps_data[app_name]

		config.set_value(app_name, "exe_path", app_data.get("exe_path", ""))
		config.set_value(app_name, "icon_path", app_data.get("icon_path", ""))
		config.set_value(app_name, "category", app_data.get("category", "Uncategorized"))

		var workspaces_str_array = []
		for ws_id in app_data.get("workspaces", []):
			workspaces_str_array.append(str(ws_id))
		config.set_value(app_name, "workspaces", ",".join(workspaces_str_array))

		config.set_value(app_name, "quick_menu_slot", app_data.get("quick_menu_slot", -1))
		
	var error = config.save(APPS_CONFIG_PATH)
	if error == OK:
		print("App configurations saved to:", APPS_CONFIG_PATH)
	else:
		push_error("Error saving app configurations: ", error)
		
		
		
func import_filtered_filtered_apps_from_json():
	print("Attempting to import filtered apps from:", FILTERED_APPS_JSON_PATH)

	var file = FileAccess.open(FILTERED_APPS_JSON_PATH, FileAccess.READ)
	if not file:
		push_error("Failed to open filtered_apps.json at: " + FILTERED_APPS_JSON_PATH)
		return

	var json_string = file.get_as_text()
	file.close()

	var parsed_json = JSON.parse_string(json_string)

	if parsed_json is Dictionary:
		print("Successfully parsed filtered_apps.json.")
		for app_name in parsed_json.keys():
			var app_details = parsed_json[app_name]

			if app_details is Dictionary and app_details.has("path") and app_details.has("icon"):
				var exe_path = app_details["path"]
				var icon_path = BASE_PATH + app_details["icon"]

				if configured_apps_data.has(app_name):
					var existing_data = configured_apps_data[app_name]
					if existing_data["exe_path"] != exe_path:
						existing_data["exe_path"] = exe_path
						print("Updated exe_path for existing app '{app_name}'.")
					if existing_data["icon_path"] != icon_path:
						existing_data["icon_path"] = icon_path
						print("Updated icon_path for existing app '{app_name}'.")
					# No need to explicitly set other params, they are already there

				else:
					# App is new, add it with default/empty values for other parameters
					var new_app_data = {
						"exe_path": exe_path,
						"icon_path": icon_path,
						"category": "Uncategorized", # Default category
						"workspaces": [],             # Default to empty array
						"quick_menu_slot": "null"        # Default to unassigned slot
					}
					configured_apps_data[app_name] = new_app_data
					print("Added new app '{app_name}' with default settings.")
			else:
				push_warning("Skipping malformed entry for app '{app_name}' in filtered_apps.json.")
	else:
		push_error("Failed to parse JSON from filtered_apps.json. Expected a Dictionary.")
		return # Exit if parsing failed

	# After processing all apps from the JSON, save the combined data back to disk.
	save_app_configurations()
	

func check_slot(slot_name : String):
	for app_name in configured_apps_data.keys():
		if configured_apps_data[app_name].get("quick_menu_slot") == slot_name:
			return true
		else:
			return false
	
	
func update_slot(app_name : String, slot_name : String):
	if !configured_apps_data[app_name].is_empty():
		configured_apps_data[app_name]["quick_menu_slot"] = slot_name
		save_app_configurations()
	else:
		push_error("App Not Found")
		
		
func remove_slot(app_name : String):
	if !configured_apps_data[app_name].is_empty():
		configured_apps_data[app_name]["quick_menu_slot"] = "null"
		save_app_configurations()
	else:
		push_error("App Not Found")
		
		
func get_app_name_by_slot(slot_name : String):
	for app_name in configured_apps_data.keys():
		if configured_apps_data[app_name].get("quick_menu_slot") == slot_name:
			return app_name
	return null
		
func get_icon_by_app_name(app_name : String):
	if app_name != null:
		if !configured_apps_data[app_name].is_empty():
			var icon = configured_apps_data[app_name]["icon_path"]
			return icon
		else:
			return null
	else:
		return null
			
		
func update_icon(button: Button, icon: String):
	if FileAccess.file_exists(icon):
		var tex = load(icon)
		if tex and tex is Texture2D:
			var image = tex.get_image()
			if image:
				image.resize(40, 40, Image.INTERPOLATE_LANCZOS)
				var scaled_tex = ImageTexture.create_from_image(image)
				button.icon = scaled_tex
			else:
				print("❌ Failed to get image from texture:", icon)
		else:
			print("❌ Failed to load valid texture:", icon)
	else:
		print("⚠️ Icon file not found:", icon)
		button.icon = preload("res://assets/icons/40x40/alert-square-Stroke-Rounded.png")

		
func remove_icon(button : Button):
	button.icon = preload("res://assets/icons/40x40/add-01-Stroke-Rounded.png")
	

func open_app(exe_path):
	if OS.has_feature("windows"):
		var args = []
		var output = OS.execute_with_pipe(exe_path,args)   ### ths function is new to godot 4.3 and 4.4 and is not available in lower versions ###
		var process_id = output["pid"]
		return process_id
	
func test(slot_name):
	#var slot_name = "App1"
	for app_name in configured_apps_data.keys():
		if configured_apps_data[app_name].get("quick_menu_slot") == slot_name:
			return app_name
			
		else:
			print("app_name")
