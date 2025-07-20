extends Button

@onready var clear: Button = $Clear
#var app_button_active = false
var unique_id
var active_buttons = []
var _workspace_id
var _app_name
var _app_exe
var _app_icon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear.visible = false
	var parents = []
	get_workspace()
	unique_id = str(_workspace_id) + self.name
	
	var app_data = WorkspaceManager.get_app(_workspace_id, self.name)
	if app_data and app_data.has("app_name"):
		_app_name = app_data["app_name"]
		_app_exe = app_data["app_path"]
		_app_icon = app_data["app_icon"]

		print(_app_name, _app_exe, _app_icon)

		if not _app_icon.is_empty():
			AppManager.update_icon(self, _app_icon)
	else:
		pass
		#push_warning("App data not found for: workspace_id = %s, slot = %s" % [_workspace_id, self.name]))


	#print(self.name , _workspace_id)
	
	


func _process(delta: float) -> void:
	if GameManager.ws_edit:
		self.disabled = true
		clear.disabled = false
		clear.visible = true
	else:
		self.disabled = false
		clear.visible = false
		
	#for i in AppManager.test_data[id]:
		#print(i)
	#print(AppManager.test_data[id][1])

func _on_pressed() -> void:
	if unique_id in active_buttons:
		pass
		
	else:
		var AppWindow = preload("res://scenes/app_list_window.tscn")  # Adjust path if needed
		var applist_instance = AppWindow.instantiate()
		get_tree().root.add_child(applist_instance)
		applist_instance.visible = true
		
		#var screen_size = DisplayServer.screen_get_size()
		#var app_list_height = applist_instance.size.y if applist_instance.size.y > 0 else 600
#
		#var space_on_top = GameManager.menu_window.position.y
		#var space_on_bottom = screen_size.y - (GameManager.menu_window.position.y + GameManager.menu_window.size.y)
		#
#
#
		#if space_on_bottom >= applist_instance.size.y or space_on_bottom >= space_on_top:
			#GameManager.applist_pos = Vector2(
				#GameManager.menu_window.position.x,
				#GameManager.menu_window.position.y + GameManager.menu_window.size.y
			#)
		#else:
			#GameManager.applist_pos = Vector2(
				#GameManager.menu_window.position.x,
				#GameManager.menu_window.position.y - applist_instance.size.y
			#)
			#
		#applist_instance.set_window_position()
		
		applist_instance.app_list.app_selected.connect(func(app_name, app_path, app_icon):
			print("Selected:", app_name, app_path, app_icon)
			
			
			WorkspaceManager.set_app(_workspace_id, self.name,app_name,app_path,app_icon)
			AppManager.update_icon(self,app_icon)
			active_buttons.append(unique_id)
			_app_name = app_name

		)


func get_workspace():
	var workspace = get_parent()
	while workspace and workspace.name != "Workspace ":
		if workspace.name.begins_with("Workspace "):
			_workspace_id = extract_workspace_id(workspace.name)
		workspace = workspace.get_parent()
	

func extract_workspace_id(name: String) -> int:
	var parts = name.strip_edges().split(" ")
	if parts.size() == 2 and parts[1].is_valid_int():
		return parts[1].to_int()
	else:
		push_warning("⚠️ Invalid workspace name format: " + name)
		return -1  # or another fallback value

func _on_clear_pressed() -> void:
	WorkspaceManager.remove_app(_workspace_id, self.name)
	AppManager.remove_icon(self)
	active_buttons.erase(unique_id)
	_app_name = null
	print("clear")
	#app_button_active = false
