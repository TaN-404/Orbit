extends Control

@onready var voice_command: Label = $PanelContainer/Panel/MarginContainer/VBoxContainer/Panel/VoiceCommand

var message_number = 0
var message

var speech_text = "voice command"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if SpeechListener.test_voice_mode:
		if SpeechListener.listener_ready: 
			message = SpeechListener.get_latest_speech()
			if message["Number"] > message_number:
				speech_text = message["Message"]
				message_number += 1
				
	voice_command.text = speech_text

func _on_check_button_toggled(toggled_on: bool) -> void:
	SpeechListener.test_voice_mode = !SpeechListener.test_voice_mode
	
	if !SpeechListener.test_voice_mode:
		SpeechListener.kill_process(SpeechListener.speech_process_id)
		SpeechListener.client_active = false
		var exe = "speech_client.exe"
		SpeechListener.cleanup_process(exe)
