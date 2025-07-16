extends Button

@onready var clear: Button = $Clear
#var app_button_active = false

var active_buttons = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear.visible = false
	clear.icon = preload("res://assets/apps/clear.png")
	
	
	##icon check
	
	var exe = AppManager.button_dictionary[self.name]["exe_path"]
	var icon = AppManager.button_dictionary[self.name]["exe_icon"]
	
	if !exe.is_empty():
		active_buttons.append(self.name)
		if !icon.is_empty():
			AppManager.update_icon(self, icon)
	else:
		self.icon = preload("res://assets/apps/add-app.png")


func _process(delta: float) -> void:
	if GameManager.am_edit:
		clear.visible = true
	else:
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
	
