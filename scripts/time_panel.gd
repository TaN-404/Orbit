extends Control

@onready var time: RichTextLabel = $PanelContainer/Panel/MarginContainer/VBoxContainer/Time
@onready var update_timer: Timer = $UpdateTimer
@onready var date: RichTextLabel = $PanelContainer/Panel/MarginContainer/VBoxContainer/Date

# Called when the node enters the scene tree for the first time.
func _ready():
	time.size = Vector2(300, 65)
	#time.scroll_active = false
	#time.fit_content = false  # Disable auto-resize
	#time.autowrap_mode = TextServer.AUTOWRAP_OFF
	##time.text_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#time.add_theme_font_size_override("normal_font_size", 32)
	#time.add_theme_constant_override("text_margin_top", -10)  # Adjust vertical centering
#
	## Configure Date Label
	date.size = Vector2(300, 65)
	#date.scroll_active = false
	#date.fit_content = false
	#date.autowrap_mode = TextServer.AUTOWRAP_OFF
	##date.text_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#date.add_theme_font_size_override("normal_font_size", 32)
	#date.add_theme_constant_override("text_margin_top", -10)
	#
	time.push_font_size(32)
	date.push_font_size(32)
	update_time()  # Initialize immediately
	update_timer.timeout.connect(update_time)  # Connect timer signal

func update_time():
	var time_now = Time.get_time_dict_from_system()
	var date_now = Time.get_date_dict_from_system()
	
	# Format with time on first line, date on second (size 32, centered)
	var time_text = """
	%02d:%02d:%02d
	""" % [
		time_now.hour, time_now.minute, time_now.second
	]
	var date_text  = """
	%04d-%02d-%02d
	""" % [
		date_now.year, date_now.month, date_now.day
	]
	
	time.text = time_text
	date.text = date_text
