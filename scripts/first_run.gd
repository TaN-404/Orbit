extends Window

@onready var intro: Control = $PanelContainer/Panel/MarginContainer/Intro
@onready var settings_setup: Control = $PanelContainer/Panel/MarginContainer/SettingsSetup
@onready var move: Button = $VBoxContainer/HBoxContainer/Move
@onready var exit: Button = $VBoxContainer/HBoxContainer/Exit

var dragging = false
var drag_offset := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit.pass_parent(self)
	move.pass_parent(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
