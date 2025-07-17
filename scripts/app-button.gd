extends Button

@onready var clear: Button = $Clear
#var app_button_active = false

var active_buttons = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear.visible = false

	
	var exe = AppManager.button_dictionary[self.name]["exe_path"]
	var icon = AppManager.button_dictionary[self.name]["exe_icon"]
	
	if !exe.is_empty():
		active_buttons.append(self.name)
		if !icon.is_empty():
			AppManager.update_icon(self, icon)
	else:
		#self.icon = preload("res://assets/icons/add-01-Stroke-Rounded.png")
		pass


func _process(delta: float) -> void:
	if GameManager.am_edit:
		self.disabled = true
		clear.disabled = false
		clear.visible = true
	else:
		self.disabled = false
		clear.visible = false


func _on_pressed() -> void:
	
	if self.name in active_buttons:
		var exe_path = AppManager.button_dictionary[self.name]["exe_path"]
		var process_id = AppManager.open_app(exe_path)
		
	else:
		var AppWindow = preload("res://scenes/app_list_window.tscn")  # Adjust path if needed
		var applist_instance = AppWindow.instantiate()
		get_tree().root.add_child(applist_instance)
		applist_instance.visible = true
		
		var screen_size = DisplayServer.screen_get_size()
		var app_list_height = applist_instance.size.y if applist_instance.size.y > 0 else 600

		var space_on_top = GameManager.menu_window.position.y
		var space_on_bottom = screen_size.y - (GameManager.menu_window.position.y + GameManager.menu_window.size.y)
		


		if space_on_bottom >= applist_instance.size.y or space_on_bottom >= space_on_top:
			GameManager.applist_pos = Vector2(
				GameManager.menu_window.position.x,
				GameManager.menu_window.position.y + GameManager.menu_window.size.y
			)
		else:
			GameManager.applist_pos = Vector2(
				GameManager.menu_window.position.x,
				GameManager.menu_window.position.y - applist_instance.size.y
			)
			
		applist_instance.set_window_position()
		
		applist_instance.app_list.app_selected.connect(func(name, path, icon):
			print("Selected:", name, path, icon)
			
			AppManager.update_button(self.name,path,icon)
			AppManager.update_icon(self, icon)
			active_buttons.append(self.name)

		)



func _on_clear_pressed() -> void:
	AppManager.remove_button(self.name)
	AppManager.remove_icon(self)
	active_buttons.erase(self.name)
	#app_button_active = false
