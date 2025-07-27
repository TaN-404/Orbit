extends Window

@onready var move: Button = $"Notes-app/VBoxContainer/MarginContainer/HBoxContainer/Move"
@onready var exit: Button = $"Notes-app/VBoxContainer/MarginContainer/HBoxContainer/Exit"
@onready var pin: Button = $"Notes-app/VBoxContainer/MarginContainer/HBoxContainer/Pin"

var is_active = false
var dragging := false
var drag_offset := Vector2.ZERO

func _ready() -> void:
	if GameManager.on_top:
		GameManager.always_on_top(self)
	self.borderless = true
	self.transparent_bg = true
	self.transparent = true
	self.size = Vector2(400, 400)
	exit.pass_parent(self)
	move.pass_parent(self)

	#move.mouse_filter = Control.MOUSE_FILTER_PASS


func _process(_delta: float) -> void:
	pass




#func _on_exit_pressed() -> void:
	#queue_free() # Replace with function body.


func _on_pin_toggled(toggled_on: bool) -> void:
	if toggled_on:
		pin.icon = preload("res://assets/icons/24x24/pin-off-Stroke-Rounded.png")
	else:
		pin.icon = preload("res://assets/icons/24x24/pin-Stroke-Rounded.png")
