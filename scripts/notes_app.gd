extends Control

@onready var _notes_window : Window = get_window()
@onready var tab_container = $VBoxContainer/TabContainer
@onready var menu_bar = $VBoxContainer/MenuBar
@onready var status_bar = $VBoxContainer/StatusBar/StatusLabel

func  _ready() -> void:
	_notes_window.visible = false
	_setup_menu()

func _setup_menu():
	# File menu
	var file_menu := PopupMenu.new()
	file_menu.name = "FileMenu"
	file_menu.add_item("New")
	#file_menu.set_item_accelerator(file_menu.get_item_index(KEY_N), KEY_MASK_CTRL)
	file_menu.add_item("Open")
	#file_menu.set_item_accelerator(file_menu.get_item_index(KEY_O), KEY_MASK_CTRL)
	file_menu.add_item("Save")
	#file_menu.set_item_accelerator(file_menu.get_item_index(KEY_S), KEY_MASK_CTRL)
	file_menu.add_item("Save As")
	file_menu.set_item_accelerator(file_menu.get_item_index(KEY_S), KEY_MASK_CTRL | KEY_MASK_SHIFT)
	file_menu.add_separator()
	file_menu.add_item("Exit")
	#file_menu.set_item_accelerator(file_menu.get_item_index(KEY_Q), KEY_MASK_CTRL)
	
	menu_bar.add_child(file_menu)
	file_menu.id_pressed.connect(_on_file_menu_pressed)
	
func _on_file_menu_pressed(id):
	var item = $VBoxContainer/MenuBar/FileMenu.get_item_text(id)
	match item:
		"New":
			_add_new_tab()
		"Open":
			pass
			#_open_file()
		"Save":
			pass
			#_save_file()
		"Save As":
			pass
			#_save_file_as()
		"Exit":
			get_tree().quit()
			
			
func _add_new_tab(name: String = "Untitled", content: String = ""):
	print("new tab")
	var text_edit = TextEdit.new()
	text_edit.name = name
	text_edit.text = content
	text_edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	text_edit.text_changed.connect(_update_status_bar.bind("Editing: " + name))
	
	tab_container.add_child(text_edit)
	tab_container.set_tab_title(tab_container.get_child_count() - 1, name)
	tab_container.current_tab = tab_container.get_child_count() - 1
	
	_update_status_bar("Created new tab: " + name)
	
	
func _update_status_bar(message: String):
	status_bar.text = message
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.ctrl_pressed:
			match event.keycode:
				KEY_N:
					_add_new_tab()
				KEY_O:
					pass
					#_open_file()
				KEY_S:
					if event.shift_pressed:
						pass
						#_save_file_as()
					else:
						pass
						#_save_file()
				KEY_W:
					pass
					#_close_current_tab()
