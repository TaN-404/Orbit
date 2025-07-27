extends Control
@onready var app_info: Control = $"../AppInfo"

var previous
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _previous_screen(screen):
	previous = screen
	


func _on_previous_pressed() -> void:
	self.hide()
	previous.show()


func _on_next_pressed() -> void:
	self.hide()
	app_info.show()
	app_info._previous_screen(self)
	
