extends Window

@onready var _app_list_window : Window = get_window()
@onready var app_list: Control = $MarginContainer/VBoxContainer/AppList
@onready var exit: Button = $MarginContainer/VBoxContainer/HBoxContainer/Exit
@onready var move: Button = $MarginContainer/VBoxContainer/HBoxContainer/Move

var is_active = false
var dragging = false
var drag_offset := Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_app_list_window.borderless = true
	_app_list_window.transparent = true
	_app_list_window.transparent_bg = true
	
	_app_list_window.size = Vector2(680, 385)
	#print(GameManager.applist_pos)
	#_app_list_window.position = Vector2(1000,1000)
	exit.pass_parent(self)
	move.pass_parent(self)
	

func set_window_position():
	_app_list_window.position = GameManager.applist_pos
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
