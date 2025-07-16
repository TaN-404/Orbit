extends Window


@onready var _menu_window : Window = get_window()
var main : Node2D

var is_active = false
var dragging = false
var drag_offset := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_menu_window.borderless = true
	_menu_window.transparent = true
	_menu_window.transparent_bg = true
	
	GameManager.menu_window = _menu_window
	
	_menu_window.size = Vector2(120, 312)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		position = (Vector2(DisplayServer.mouse_get_position()) + drag_offset).round()



func _on_exit_pressed() -> void:
	GameManager.app_menu_active = false
	queue_free()


func _on_move_button_down() -> void:
	dragging = true
	drag_offset = position - DisplayServer.mouse_get_position()


func _on_move_button_up() -> void:
	dragging = false


func _on_add_apps_pressed() -> void:
	print("applist window instantiating")
	var AppWindow = preload("res://scenes/app_list_window.tscn")  # Adjust path if needed
	var applist_instance = AppWindow.instantiate()
	get_tree().root.add_child(applist_instance)
	applist_instance.visible = true
	
	applist_instance.position.y = _menu_window.position.y - applist_instance.size.y
	applist_instance.position = Vector2(1000,1000)
	
	var screen_size = DisplayServer.screen_get_size()
	var app_list_height = applist_instance.size.y if applist_instance.size.y > 0 else 600
	
	var space_on_top = _menu_window.position.y
	var space_on_bottom = screen_size.y - (_menu_window.position.y + _menu_window.size.y)
	
	print(space_on_bottom)
	print(space_on_top)
	
	
	if space_on_bottom >= applist_instance.size.y or space_on_bottom >= space_on_top:
		GameManager.applist_pos = Vector2(
			_menu_window.position.x,
			_menu_window.position.y + _menu_window.size.y
		)
	else:
		GameManager.applist_pos = Vector2(
			_menu_window.position.x,
			_menu_window.position.y - applist_instance.size.y
		)
	applist_instance.app_list.app_selected.connect(func(name, path, icon):
		print("Selected:", name, path, icon)
	)
	#var tab_name = "App"
	#await settings_instance.ready
	#settings_instance.open_tab(tab_name)


func _on_edit_pressed() -> void:
	GameManager.am_edit = !GameManager.am_edit
