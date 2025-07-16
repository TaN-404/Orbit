extends GridContainer

func _ready():
	# Connect all buttons' pressed signals to one handler
	for child in get_children():
		if child is Button:
			var icon = AppManager.button_dictionary[child.name]["exe_icon"]
			if FileAccess.file_exists(icon):
				var tex = load(icon)
				if tex and tex is Texture2D:
					var image = tex.get_image()
					if image:
						image.resize(40, 40, Image.INTERPOLATE_LANCZOS)
						var scaled_tex = ImageTexture.create_from_image(image)
						child.icon = scaled_tex
					else:
						print("❌ Failed to get image from texture:", icon)
				else:
					print("❌ Failed to load valid texture:", icon)
			else:
				print("⚠️ Icon file not found:", icon)
			child.pressed.connect(_on_button_pressed.bind(child.name, child))

func _on_button_pressed(button_name, button):
	if GameManager.am_edit:
		var AppWindow = preload("res://scenes/app_list_window.tscn")  # Adjust path if needed
		var applist_instance = AppWindow.instantiate()
		get_tree().root.add_child(applist_instance)
		applist_instance.visible = true
		
		applist_instance.app_list.app_selected.connect(func(name, path, icon):
			print("Selected:", name, path, icon)
			
			AppManager.update_button(button_name,path,icon)
			AppManager.update_icon(button, icon)

		)
		

	else:
		var exe_path = AppManager.button_dictionary[button_name]["exe_path"]
		var process_id = AppManager.open_app(exe_path)
		print(AppManager.button_dictionary[button_name])
		print("Button pressed;", button_name)



func _on_edit_pressed() -> void:
	GameManager.am_edit = !GameManager.am_edit
