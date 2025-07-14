extends Window

@onready var move: Button = $"Notes-app/VBoxContainer/MarginContainer/HBoxContainer/Move"

var dragging := false
var drag_offset := Vector2.ZERO

func _ready() -> void:
	self.borderless = true
	self.transparent_bg = true
	self.transparent = true
	self.size = Vector2(400, 400)

	#move.mouse_filter = Control.MOUSE_FILTER_PASS


func _process(_delta: float) -> void:
	if dragging:
		position = (Vector2(DisplayServer.mouse_get_position()) + drag_offset).round()

func _on_move_button_down() -> void:
	dragging = true
	drag_offset = position - DisplayServer.mouse_get_position()


func _on_move_button_up() -> void:
	dragging = false


func _on_exit_pressed() -> void:
	queue_free() # Replace with function body.
