extends Node

"""SIGNAlS"""
signal app_added

"""CLIENTS"""
const SEARCH_APPS = "res://bin/search_client.exe"
const ADD_APP = "res://bin/add_app.exe"


const BASE_USER_PATH = "user://"
const BASE_PATH := "res://bin/"
const GAME_DATA_PATH = "user://config_files"
const APPS_CONFIG_PATH = "user://config_files/app_menu.cfg"
const FILTERED_APPS_JSON_PATH = "user://app_data/filtered_apps.json"
const APP_ICON_PATH = "user://app_data/app_icons/"

var configured_apps_data = {}
var workspace_data = {}

var test_data = {
	1:["app1", "app2"],
	2:["app3"]
}

func _ready() -> void:
	check_and_create_directories()
	load_app_configurations()
	import_filtered_filtered_apps_from_json()
	

func check_and_create_directories() -> void:
	var dir = DirAccess.open("user://")
	if dir:
		# Check and create game_data directory
		if not dir.dir_exists("config_files"):
			dir.make_dir("config_files")
			print("Created directory: config_files")
	if dir:
		# Check and create game_data directory
		if not dir.dir_exists("app_data"):
			dir.make_dir("app_data")
			print("Created directory: app_data")
			
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
			
			app_data["quick_menu_slot"] = config.get_value(app_name, "quick_menu_slot", "null")
			app_data["voice_command"] = config.get_value(app_name, "voice_command", "")

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

		
		config.set_value(app_name, "quick_menu_slot", app_data.get("quick_menu_slot", "null"))
		config.set_value(app_name, "voice_command", app_data.get("voice_command", ""))
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
				var icon_path = app_details["icon"]

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
						"quick_menu_slot": "null",   
						"voice_command": ""     # Default to unassigned slot
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

func get_apps():
	var full_path = ProjectSettings.globalize_path(BASE_USER_PATH)
	var full_exe_path = ProjectSettings.globalize_path(SEARCH_APPS)
	var arguments = []
	arguments.append(full_path)
	var exit_code = OS.execute(full_exe_path, arguments)

	if exit_code == 0:
		print("\nPython script executed successfully.")
		# Now you can proceed to load your filtered_apps.json and icons from user://app_data/ 
	else:
		print("\nPython script execution failed with exit code: ", exit_code)
	import_filtered_filtered_apps_from_json()
		
	
	
func add_app(app_path : String):
	var json_path = ProjectSettings.globalize_path(FILTERED_APPS_JSON_PATH)
	var app_icon_folder_path = ProjectSettings.globalize_path(APP_ICON_PATH)
	var full_app_path = ProjectSettings.globalize_path(ADD_APP)
	
	var arguments = [
		json_path,
		app_icon_folder_path,
		app_path
	]
	
	var exit_code = OS.execute(full_app_path, arguments)
	if exit_code == 0:
		print("App added successfully")
	
	import_filtered_filtered_apps_from_json()

	
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
		var image = Image.new()
		var load_error = image.load(icon)
		
		if load_error == OK:
			var tex = ImageTexture.create_from_image(image) # Create a Texture from the Image data
			tex.set_size_override(Vector2i(40,40))
			if tex:
				button.icon = tex
		else:
			var tex = load(icon)
			if tex and tex is Texture2D:
				var image_new = tex.get_image()
				if image_new:
					image_new.resize(40, 40, Image.INTERPOLATE_LANCZOS)
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
		return 
		
		
func get_all_pids_by_exe_name(exe_name: String) -> Array:
	var output := []
	var cmd := "tasklist /FI \"IMAGENAME eq %s\" /FO CSV /NH" % exe_name
	var exit_code := OS.execute("cmd", ["/C", cmd], output, true)

	var pids := []

	for line in output:
		if line.strip_edges() == "":
			continue
		var parts = line.split(",")
		if parts.size() >= 2:
			var pid_str = parts[1].strip_edges().replace("\"", "")
			var pid = pid_str.to_int()
			if pid > 0:
				pids.append(pid)
	return pids


func kill_process(pid):
	if OS.has_feature("windows") and pid != -1:
		OS.kill(pid) 
		
