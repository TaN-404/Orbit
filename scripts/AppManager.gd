extends Node

const APP_CONFIG_PATH = "user://app_menu.cfg"
var button_dictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_buttons()
	load_apps()
	print(button_dictionary)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#for button_name in button_dictionary:
		#var button_data = button_dictionary[button_name]
		#print(button_data)
	pass

func initialize_buttons():
	# Clear existing dictionary
	button_dictionary.clear()

	# Add all 8 buttons with default values
	for i in range(1, 9):
		var button_name = "App%d" % i
		button_dictionary[button_name] = {
			"exe_path": "",
			"exe_icon": ""
		}






func save_apps():
	var config = ConfigFile.new()
	
	# Save each button's data under its own section
	for button_name in button_dictionary:
		var button_data = button_dictionary[button_name]
		config.set_value(button_name, "exe_path", button_data["exe_path"])
		config.set_value(button_name, "exe_icon", button_data["exe_icon"])
	
	if config.save(APP_CONFIG_PATH) != OK:
		push_error("Failed to save button data")
	else:
		print("All buttons saved successfully")
	print(config)
		
	
	
func update_button(button_name: String, exe_path: String, exe_icon: String):
	if button_name in button_dictionary:
		button_dictionary[button_name]["exe_path"] = exe_path
		button_dictionary[button_name]["exe_icon"] = exe_icon
		save_apps()
	else:
		push_error("Button %s not found" % button_name)
		
		
func remove_button(button_name : String):
	if button_name in button_dictionary:
		button_dictionary[button_name]["exe_path"] = ""
		button_dictionary[button_name]["exe_icon"] = ""
		save_apps()
	else:
		push_error("Button %s not found" % button_name)
	
	
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
		button.icon = preload("res://assets/apps/unknown-app.png")

		
func remove_icon(button : Button):
	button.icon = preload("res://assets/apps/add-app.png")

	
func load_apps() :
	var config = ConfigFile.new()


	if config.load(APP_CONFIG_PATH) != OK:
		print("No saved button data found, using defaults")
		#initialize_buttons()
		return
	
	# Load each button that exists in the config
	for button_name in config.get_sections():
		if button_name.begins_with("App"):  # "ButtonX"
			button_dictionary[button_name] = {
				"exe_path": config.get_value(button_name, "exe_path", ""),
				"exe_icon": config.get_value(button_name, "exe_icon", "")
			}
	
	# Ensure all 8 buttons exist (in case config was incomplete)
	#for i in range(1, 9):
		#var button_name = "Button%d" % i
		#if not button_name in button_dictionary:
			#button_dictionary[button_name] = {"exe_path": "", "exe_icon": ""}
			
			
			
func open_app(exe_path):
	if OS.has_feature("windows"):
		var args = []
		var output = OS.execute_with_pipe(exe_path,args)   ### ths function is new to godot 4.3 and 4.4 and is not available in lower versions ###
		var process_id = output["pid"]
		return process_id
