extends Node2D

@onready var _MainWindow: Window = get_window()
var notes_instance : Window = null
var message_number = 0
var message

var drag_offset := Vector2.ZERO
var window_dragging := false

@export var sticky_notes : PackedScene
@export var settings : PackedScene
@export var QuickMenu : PackedScene

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


func _on_quick_menu_pressed() -> void:
	if QuickMenu != null:
		var quickm_instance = QuickMenu.instantiate()
		add_child(quickm_instance)
		quickm_instance.visible = true
		var screen_size = DisplayServer.screen_get_size()
		var main_window_pos = _MainWindow.position
		var main_window_size = _MainWindow.size
		
		# QuickMenu size (adjust if needed)
		var quick_menu_width = quickm_instance.size.x if quickm_instance.size.x > 0 else 200

		# Check if QuickMenu fits on the right side
		var space_on_right = screen_size.x - (main_window_pos.x + main_window_size.x)
		var space_on_left = main_window_pos.x

		if space_on_right >= quick_menu_width or space_on_right >= space_on_left:
			# Place on the right
			quickm_instance.position = Vector2(
				main_window_pos.x + main_window_size.x,
				main_window_pos.y
			)
		else:
			# Place on the left
			quickm_instance.position = Vector2(
				main_window_pos.x - quick_menu_width,
				main_window_pos.y
			)
		
		# Ensure QuickMenu doesn't go off-screen (clamping)
		quickm_instance.position.x = clamp(
			quickm_instance.position.x,
			0,
			screen_size.x - quick_menu_width
		)
