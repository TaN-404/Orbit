extends Node2D

@onready var _MainWindow: Window = get_window()
var notes_instance : Window = null
var message_number = 0
var message

var drag_offset := Vector2.ZERO
var window_dragging := false

@export var sticky_notes : PackedScene
@export var settings : PackedScene

@onready var menu: Control = $Menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_MainWindow.borderless = true
	_MainWindow.transparent = true
	_MainWindow.transparent_bg = true
	_MainWindow.unresizable = true
	#_MainWindow.mouse_passthrough = true
	_MainWindow.always_on_top = true
	# NOTES APP
	
	menu.visible = false
	
	print(_MainWindow.get_size_with_decorations())
	_MainWindow.size = Vector2(320, 320)
	print(_MainWindow.get_size_with_decorations())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if window_dragging:
		_MainWindow.position = (Vector2(DisplayServer.mouse_get_position()) + drag_offset).round()
	
	if SpeechListener.voice_mode:
		if SpeechListener.listener_ready: 
			message = SpeechListener.get_latest_speech()
			if message["Number"] > message_number:
				print(message["Message"])
				message_number += 1


func _on_test_pressed() -> void:
		if notes_instance == null:
			var NotesScene = preload("res://scenes/settings.tscn")  # Adjust path if needed
			notes_instance = NotesScene.instantiate()
			add_child(notes_instance)
			notes_instance.visible = true
		#SpeechListener.voice_mode = true
		#var path = "C:/Program Files/Microsoft VS Code/code.exe"
		#var commad = "code.exe"
		#var exit_code = OS.execute_with_pipe(path, [])


func _on_menu_button_pressed() -> void:
	menu.visible = !menu.visible

func _on_move_window_button_button_down() -> void:
	window_dragging = true
	print("down")
	drag_offset = _MainWindow.position - (DisplayServer.mouse_get_position())


func _on_move_window_button_button_up() -> void:
	window_dragging = false
	print("up")
	
	
"""MENU BUTTONS"""

func _on_exit_pressed() -> void:
	get_tree().quit()
	


func _on_settings_pressed() -> void:
	if settings != null: # Adjust path if needed
		var setting_instance = settings.instantiate()
		add_child(setting_instance)
		setting_instance.visible = true
