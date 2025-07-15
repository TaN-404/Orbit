extends Window

@onready var _settings_window : Window =  get_window()
# Called when the node enters the scene tree for the first time.
@onready var move: Button = $Settings_control/PanelContainer/Panel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Move
@onready var settings_tab: TabContainer = $Settings_control/PanelContainer/Panel/MarginContainer/VBoxContainer/SettingsTab
@onready var app: TabBar = $Settings_control/PanelContainer/Panel/MarginContainer/VBoxContainer/SettingsTab/App


var dragging = false
var drag_offset := Vector2.ZERO

func _ready() -> void:
	_settings_window.borderless = true
	_settings_window.size = Vector2(720, 480)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		position = (Vector2(DisplayServer.mouse_get_position()) + drag_offset).round()	


func _on_exit_pressed() -> void:
	queue_free() # Replace with function body.


func _on_move_button_down() -> void:
	dragging = true
	drag_offset = position - DisplayServer.mouse_get_position()


func _on_move_button_up() -> void:
	dragging = false
	
	
func open_tab(tab_name: String):
	print(tab_name)
	for i in settings_tab.get_tab_count():
		if settings_tab.get_tab_title(i) == tab_name:
			settings_tab.current_tab = i
			break
