extends Node

var app_menu_active = false
var settings_active = false
var sticky_notes_active = false

"""QM FLAGS"""
var am_edit = false
var ws_edit = false


"""AppList"""
var app_list_standalone : bool
var applist_pos : Vector2

"""Windows"""
var menu_window : Window
var settings_window : Window
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func convert_spelled_number_to_digit(text: String) -> String:
	"""
	Converts common spelled-out numbers (zero to ninety-nine, and some hundreds/thousands)
	in a string to their digit equivalents.
	Note: This is a simple word-for-word replacement.
	It does NOT handle complex number parsing like "one hundred and twenty-three".
	"""
	var number_map = {
		# Single digits
		"zero": "0", "one": "1", "two": "2", "three": "3", "four": "4",
		"five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9",
		
		# Teens
		"ten": "10", "eleven": "11", "twelve": "12", "thirteen": "13", 
		"fourteen": "14", "fifteen": "15", "sixteen": "16", 
		"seventeen": "17", "eighteen": "18", "nineteen": "19",
		
		# Tens
		"twenty": "20", "thirty": "30", "forty": "40", "fifty": "50", 
		"sixty": "60", "seventy": "70", "eighty": "80", "ninety": "90",
		
		# Higher magnitudes (handle with care, as they often combine)
		# For simplicity, these are just direct replacements.
		# "hundred": "100",
		# "thousand": "1000",
		# "million": "1000000"
	}

	var words: PackedStringArray = text.split(" ")
	var converted_words: PackedStringArray = []
	
	for word in words:
		var lower_word = word.to_lower()
		if number_map.has(lower_word):
			converted_words.append(number_map[lower_word])
		else:
			converted_words.append(word)
			
	return " ".join(converted_words)
