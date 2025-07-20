extends Control

@onready var title: Label = $PanelContainer/Panel/MarginContainer/VBoxContainer/Title
@onready var edit_apps: Button = $PanelContainer/Panel/MarginContainer/VBoxContainer/EditApps
@onready var h_box_container: HBoxContainer = $PanelContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer


var workspace_id
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title.text = self.name
	#workspace_id = get_workspace_id(self.name)
	#print(workspace_id)
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_edit_apps_pressed() -> void:
	GameManager.ws_edit = !GameManager.ws_edit

#func _pass_ids():
	#for child in h_box_container.get_children():
		#child.ready(workspace_id)
