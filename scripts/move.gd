extends Button

@onready var _parent
var dragging = false
var drag_offset := Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		_parent.position = (Vector2(DisplayServer.mouse_get_position()) + drag_offset).round()	
	
func pass_parent(parent):
	_parent = parent


func _on_button_down() -> void:
	dragging = true
	drag_offset = _parent.position - DisplayServer.mouse_get_position()


func _on_button_up() -> void:
	dragging = false
