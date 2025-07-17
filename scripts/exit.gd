extends Button

@onready var _parent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func pass_parent(parent):
	_parent = parent

func _on_pressed() -> void:
	_parent.is_active = false
	_parent.queue_free()
