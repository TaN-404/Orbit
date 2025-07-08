extends Node2D

@onready var _MainWindow: Window = get_window()
var notes_instance : Window = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_MainWindow.borderless = true
	_MainWindow.transparent = true
	_MainWindow.transparent_bg = true
	_MainWindow.unresizable = true
	#_MainWindow.mouse_passthrough = true
	
	# NOTES APP


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_test_pressed() -> void:
		if notes_instance == null:
			var NotesScene = preload("res://scenes/notes.tscn")  # Adjust path if needed
			notes_instance = NotesScene.instantiate()
			add_child(notes_instance)
			notes_instance.visible = true
