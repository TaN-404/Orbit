extends Control
@onready var app_info: Control = $"../AppInfo"
@onready var run_on_startup: CheckBox = $PanelContainer/Panel/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/RunOnStartup
@onready var always_on_top: CheckBox = $PanelContainer/Panel/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AlwaysOnTop

var previous
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	run_on_startup.button_pressed = GameManager.startup
	always_on_top.button_pressed = GameManager.on_top

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _previous_screen(screen):
	previous = screen
	


func _on_previous_pressed() -> void:
	self.hide()
	previous.show()


func _on_next_pressed() -> void:
	self.hide()
	app_info.show()
	app_info._previous_screen(self)
	


func _on_always_on_top_toggled(toggled_on: bool) -> void:
	GameManager.on_top = toggled_on
	GameManager._on_top_changed()
	GameManager.save_settings()


func _on_run_on_startup_toggled(toggled_on: bool) -> void:
	GameManager.startup = toggled_on
	GameManager.save_settings()
