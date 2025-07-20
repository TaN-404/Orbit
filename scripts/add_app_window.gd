extends Window

const FIND_APP = "res://bin/find_exe.exe"

@onready var add_app_window : Window = get_window()
@onready var move: Button = $AddApp/VBoxContainer/HBoxContainer/Move
@onready var exit: Button = $AddApp/VBoxContainer/HBoxContainer/Exit
@onready var addexe: LineEdit = $AddApp/VBoxContainer/PanelContainer/Panel/MarginContainer/VBoxContainer/Addexe
@onready var confirm: Button = $AddApp/VBoxContainer/PanelContainer/Panel/MarginContainer/VBoxContainer/MarginContainer/Confirm

@onready var _parent
var dragging = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_app_window.borderless = true
	add_app_window.transparent = true
	add_app_window.transparent_bg = true
	add_app_window.size = Vector2(300, 232)
	
	exit.pass_parent(self)
	move.pass_parent(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pass_parent(parent):
	_parent = parent
	
func _exit_tree() -> void:
	_parent.add_app.disabled = false


func _on_confirm_pressed() -> void:
	add_new_app(addexe.text)
	queue_free()

		
func add_new_app(exe_path : String):
	print(exe_path)
	var output
	var err = OS.execute_with_pipe(FIND_APP, [exe_path])
	print(err)
	_parent.app_added()
