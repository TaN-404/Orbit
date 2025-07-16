extends Control

signal app_selected(app_name: String, app_path: String, icon_path: String)
@onready var app_list_window: Window = $"../../.."

@onready var container: VBoxContainer = $PanelContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var search_box: LineEdit = $PanelContainer/Panel/MarginContainer/VBoxContainer/SearchBar
@onready var message: Label = $PanelContainer/Panel/MarginContainer/VBoxContainer/Message


var app_list = {}
const BASE_PATH := "res://bin/"
const JSON_PATH := BASE_PATH + "filtered_apps.json"
const ICON_DIR := BASE_PATH + "app_icons/"

func _ready():
	load_app_list()
	search_box.text_changed.connect(on_search_changed)
	populate_ui()

func load_app_list():
	if not FileAccess.file_exists(JSON_PATH):
		push_error("❌ filtered_apps.json not found at: " + JSON_PATH)
		return

	var file = FileAccess.open(JSON_PATH, FileAccess.READ)
	if file:
		var text = file.get_as_text()
		app_list = JSON.parse_string(text)
	else:
		push_error("❌ Failed to open filtered_apps.json")
		
		

func populate_ui(filter: String = ""):
	# Clear all existing app rows
	for child in container.get_children():
		child.queue_free()

	message.visible = false
	var matches = 0

	for app_name in app_list.keys():
		if filter != "" and not app_name.to_lower().contains(filter.to_lower()):
			continue

		matches += 1

		var app_info = app_list[app_name]
		var hbox = HBoxContainer.new()
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.custom_minimum_size = Vector2(0, 50)

		# Icon
		var icon_path = BASE_PATH + app_info["icon"]
		var icon = TextureRect.new()
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.custom_minimum_size = Vector2(50, 50)
		if FileAccess.file_exists(icon_path):
			var tex = load(icon_path)
			if tex:
				icon.texture = tex
		hbox.add_child(icon)

		# Label
		var label = Label.new()
		label.text = app_name.capitalize()
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		hbox.add_child(label)

		# Add Button
		var add_button = Button.new()
		add_button.text = "Add"
		add_button.custom_minimum_size = Vector2(50, 50)
		add_button.pressed.connect(func():
			emit_signal("app_selected", app_name, app_info["path"], icon_path)
			app_list_window.queue_free()
		)
		hbox.add_child(add_button)

		container.add_child(hbox)

		var sep = HSeparator.new()
		sep.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		container.add_child(sep)

	if matches == 0:
		message.visible = true



func on_search_changed(new_text: String):
	populate_ui(new_text)
