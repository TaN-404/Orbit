extends Window

@onready var _settings_window : Window =  get_window()
# Called when the node enters the scene tree for the first time.
@onready var move: Button = $Settings_control/PanelContainer/Panel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Move
@onready var settings_tab: TabContainer = $Settings_control/PanelContainer/Panel/MarginContainer/VBoxContainer/SettingsTab
@onready var app: TabBar = $Settings_control/PanelContainer/Panel/MarginContainer/VBoxContainer/SettingsTab/App
@onready var exit: Button = $Settings_control/PanelContainer/Panel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Exit

var is_active = false
var dragging = false
var drag_offset := Vector2.ZERO

func _ready() -> void:
	_settings_window.borderless = true
	_settings_window.size = Vector2(720, 480)
	
	exit.pass_parent(self)
	move.pass_parent(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func open_tab(tab_name: String):
	print(tab_name)
	for i in settings_tab.get_tab_count():
		if settings_tab.get_tab_title(i) == tab_name:
			settings_tab.current_tab = i
			break
