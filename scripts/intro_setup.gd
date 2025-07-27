extends Control

@onready var settings_setup: Control = $"../SettingsSetup"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings_setup._previous_screen(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_pressed() -> void:
	self.hide()
	settings_setup.show()
	
