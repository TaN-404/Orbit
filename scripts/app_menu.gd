extends Window

@onready var exit: Button = $Amenu/VBoxContainer/MarginContainer2/HBoxContainer/Exit
@onready var move: Button = $Amenu/VBoxContainer/MarginContainer2/HBoxContainer/Move
@onready var _menu_window : Window = get_window()
var main : Node2D

@onready var _parent
var is_active = false
var dragging = false
var drag_offset := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.on_top:
		GameManager.always_on_top(_menu_window)
	_menu_window.borderless = true
	_menu_window.transparent = true
	_menu_window.transparent_bg = true

	GameManager.menu_window = _menu_window
	
	_menu_window.size = Vector2(120, 312)
	
	exit.pass_parent(self)
	move.pass_parent(self)
	
	#GameManager.on_top_changed.connect(Callable(self, "_on_gamemanager_on_top_updated"))
	GameManager.on_top_changed.connect(_on_top_recieved)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	GameManager.on_top_changed.connect(_on_top_recieved)
	
	
func _on_top_recieved():
	GameManager.always_on_top(_menu_window)
	#print(self.name)

func pass_parent(parent):
	_parent = parent

func _on_edit_pressed() -> void:
	GameManager.am_edit = !GameManager.am_edit
	
func _exit_tree() -> void:
	GameManager.am_edit = false
	_parent.disabled = false
