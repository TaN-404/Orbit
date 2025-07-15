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
	
	_menu_window.size = Vector2(120, 270)
	

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
	var AppWindow = preload("res://scenes/app_list_window.tscn")  # Adjust path if needed
	var applist_instance = AppWindow.instantiate()
	get_tree().root.add_child(applist_instance)
	applist_instance.visible = true
	#var tab_name = "App"
	#await settings_instance.ready
	#settings_instance.open_tab(tab_name)
