extends Control

@onready var title: Label = $PanelContainer/Panel/MarginContainer/VBoxContainer/Title
@onready var edit_apps: Button = $PanelContainer/Panel/MarginContainer/VBoxContainer/EditApps

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title.text = self.name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_edit_apps_pressed() -> void:
	GameManager.ws_edit = !GameManager.ws_edit
