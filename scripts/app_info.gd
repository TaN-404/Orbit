extends Control
@onready var voice_command_info: Control = $"../VoiceCommandInfo"
@onready var first_run: Window = $"../../../../.."

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
	previous.show()
	self.hide()


func _on_next_pressed() -> void:
	self.hide()
	voice_command_info.show()
	voice_command_info._previous_screen(self)
