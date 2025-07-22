extends Node2D

@onready var _MainWindow: Window = get_window()
var notes_instance : Window = null
var message_number = 0
var message
var last_text = ""

var drag_offset := Vector2.ZERO
var window_dragging := false

@export var sticky_notes : PackedScene
@export var settings : PackedScene
@export var AppMenu : PackedScene

@onready var menu: Control = $Menu
@onready var confirm_menu: Control = $ConfirmMenu
@onready var panel_container: PanelContainer = $MenuController/MarginContainer2/PanelContainer

"""SPRITES"""
@onready var border: Sprite2D = $Border


"""LABELS"""
@onready var menu_name: RichTextLabel = $Menu/PanelContainer/Panel/MarginContainer/VBoxContainer/MenuName
@onready var confirm_message: RichTextLabel = $ConfirmMenu/PanelContainer/Panel/MarginContainer/VBoxContainer/ConfirmMessage
@onready var voice_command: Label = $MenuController/MarginContainer2/PanelContainer/Panel/VoiceCommand


"""BUTTONS"""
@onready var voice_mode_button: Button = $MenuController/MarginContainer/HBoxContainer/VoiceModeButton
@onready var quick_menu: Button = $Menu/PanelContainer/Panel/MarginContainer/VBoxContainer/QuickMenu
@onready var settings_button: Button = $Menu/PanelContainer/Panel/MarginContainer/VBoxContainer/Settings
@onready var exit: Button = $Menu/PanelContainer/Panel/MarginContainer/VBoxContainer/Exit



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
	confirm_menu.visible  = false
	panel_container.visible = false
	
	print(_MainWindow.get_size_with_decorations())
	_MainWindow.size = Vector2(320, 320)
	print(_MainWindow.get_size_with_decorations())
	
	
	#menu_name.text_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#confirm_message.text_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_name.PRESET_CENTER
	border.visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if window_dragging:
		_MainWindow.position = (Vector2(DisplayServer.mouse_get_position()) + drag_offset).round()
	
	if SpeechListener.voice_mode:
		if SpeechListener.listener_ready: 
			message = SpeechListener.get_latest_speech()
			if message["Number"] > message_number:
				last_text = message["Message"]
				message_number += 1
	
	voice_command.text = last_text
	
	
	#if FileAccess.file_exists(AppManager.BASE_PATH + "app_icons/brave.png")


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
	drag_offset = _MainWindow.position - (DisplayServer.mouse_get_position())
	border.show()


func _on_move_window_button_button_up() -> void:
	window_dragging = false
	border.hide()
	
"""MENU BUTTONS"""

func _on_exit_pressed() -> void:
	confirm_menu.visible = true
	exit.disabled = true
	


func _on_settings_pressed() -> void:
	if settings != null: # Adjust path if needed
		var setting_instance = settings.instantiate()
		add_child(setting_instance)
		setting_instance.visible = true
		settings_button.disabled = true
		setting_instance.pass_parent(settings_button)
		#setting_instance.position = Vector2(400,1000)


func _on_quick_menu_pressed() -> void:
	if AppMenu != null:
		var appm_instance = AppMenu.instantiate()
		if !appm_instance.is_active:
			add_child(appm_instance)
			quick_menu.disabled = true
			appm_instance.pass_parent(quick_menu)
			appm_instance.visible = true
			var screen_size = DisplayServer.screen_get_size()
			var main_window_pos = _MainWindow.position
			var main_window_size = _MainWindow.size
			
			# QuickMenu size (adjust if needed)
			var app_menu_width = appm_instance.size.x if appm_instance.size.x > 0 else 200

			# Check if QuickMenu fits on the right side
			var space_on_right = screen_size.x - (main_window_pos.x + main_window_size.x)
			var space_on_left = main_window_pos.x

			if space_on_right >= app_menu_width or space_on_right >= space_on_left:
				# Place on the right
				appm_instance.position = Vector2(
					main_window_pos.x + main_window_size.x,
					main_window_pos.y
				)
			else:
				# Place on the left
				appm_instance.position = Vector2(
					main_window_pos.x - app_menu_width,
					main_window_pos.y
				)
			
			# Ensure QuickMenu doesn't go off-screen (clamping)
			appm_instance.position.x = clamp(
				appm_instance.position.x,
				0,
				screen_size.x - app_menu_width
			)
		
		
		
"""CONFIRM MENU"""

func _on_yes_pressed() -> void:
	get_tree().quit()


func _on_no_pressed() -> void:
	confirm_menu.visible = false
	exit.disabled = false
	

func close_client():
	SpeechListener.kill_process(SpeechListener.speech_process_id)
	SpeechListener.client_active = false
	var exe = "speech_client.exe"
	SpeechListener.cleanup_process(exe)



func _on_voice_mode_button_toggled(toggled_on: bool) -> void:
	SpeechListener.voice_mode = !SpeechListener.voice_mode
	if toggled_on:
		panel_container.visible = true
		voice_mode_button.icon = preload("res://assets/icons/40x40/mic-01-Stroke-Rounded.png")
	else:
		panel_container.visible = false
		voice_mode_button.icon = preload("res://assets/icons/40x40/mic-off-01-Stroke-Rounded (1).png")
		close_client()


func _exit_tree() -> void:
	close_client()


func _on_button_pressed() -> void:
	var dict = {}
	var app_name  = "notes"
	var pid = 102
	if not dict.has(app_name):
		dict[app_name] = {}
		dict[app_name]["pid"] = pid
	else:
		dict[app_name]["pid"] = pid
	print(dict)
