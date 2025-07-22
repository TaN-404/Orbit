extends Window

@onready var _settings_window : Window =  get_window()
# Called when the node enters the scene tree for the first time.

@export var add_app_scene : PackedScene


@onready var move: Button = $Settings_control/PanelContainer/Panel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Move
@onready var settings_tab: TabContainer = $Settings_control/PanelContainer/Panel/MarginContainer/VBoxContainer/SettingsTab
@onready var app: TabBar = $Settings_control/PanelContainer/Panel/MarginContainer/VBoxContainer/SettingsTab/App
@onready var exit: Button = $Settings_control/PanelContainer/Panel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Exit
@onready var app_list_display: Control = $Settings_control/PanelContainer/Panel/MarginContainer/VBoxContainer/SettingsTab/App/MarginContainer/VBoxContainer/AppListDisplay
@onready var add_app: Button = $Settings_control/PanelContainer/Panel/MarginContainer/VBoxContainer/SettingsTab/App/MarginContainer/VBoxContainer/AddApp

@onready var _parent
var dragging = false
var drag_offset := Vector2.ZERO

func _ready() -> void:
	_settings_window.borderless = true
	_settings_window.size = Vector2(720, 480)
	GameManager.settings_window = _settings_window
	
	exit.pass_parent(self)
	move.pass_parent(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func pass_parent(parent):
	_parent = parent

func open_tab(tab_name: String):
	print(tab_name)
	for i in settings_tab.get_tab_count():
		if settings_tab.get_tab_title(i) == tab_name:
			settings_tab.current_tab = i
			break
			
func _exit_tree() -> void:
	_parent.disabled = false


func _on_add_app_pressed() -> void:
	print("pressed")
	if add_app_scene != null:
		var _add_app_scene = add_app_scene.instantiate()
		add_child(_add_app_scene)
		_add_app_scene.visible = true
		_add_app_scene.pass_parent(self)
		add_app.disabled = true

func app_added():
	app_list_display.refresh_list()
