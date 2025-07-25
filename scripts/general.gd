extends Control

@onready var always_on_top: CheckBox = $PanelContainer/Panel/MarginContainer/VBoxContainer/AlwaysOnTop
@onready var run_on_startup: CheckBox = $PanelContainer/Panel/MarginContainer/VBoxContainer/RunOnStartup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	always_on_top.button_pressed = GameManager.on_top
	run_on_startup.button_pressed = GameManager.startup

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_always_on_top_toggled(toggled_on: bool) -> void:
	GameManager.on_top = toggled_on
	GameManager.save_settings()


func _on_run_on_startup_toggled(toggled_on: bool) -> void:
	GameManager.startup = toggled_on
	GameManager.save_settings()
