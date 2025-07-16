extends Window

@onready var _app_list_window : Window = get_window()
@onready var app_list: Control = $MarginContainer/VBoxContainer/AppList

var dragging = false
var drag_offset := Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_app_list_window.borderless = true
	_app_list_window.transparent = true
	_app_list_window.transparent_bg = true
	
	_app_list_window.size = Vector2(680, 385)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		position = (Vector2(DisplayServer.mouse_get_position()) + drag_offset).round()	


func _on_exit_pressed() -> void:
	queue_free()


func _on_move_button_down() -> void:
	dragging = true
	drag_offset = position - DisplayServer.mouse_get_position()


func _on_move_button_up() -> void:
	dragging = false
