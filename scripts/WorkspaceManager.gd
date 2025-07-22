extends Node

var config_data: Dictionary = {}
const CONFIG_PATH := "user://config_files/workspace_config.cfg"

func _ready() -> void:
	#initialize_config()
	load_config()

# Initialize with optional default structure
func initialize_config(default_data := {}) -> void:
	config_data = default_data.duplicate(true)
	save_config()

# Load config from disk
func load_config() -> void:
	var file = FileAccess.open(CONFIG_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		config_data = str_to_var(content)
	else:
		config_data = {}

# Save current config to disk
func save_config() -> void:
	var file = FileAccess.open(CONFIG_PATH, FileAccess.WRITE)
	file.store_string(var_to_str(config_data))
	file.flush()
	file.close()

# Add or replace app in a workspace slot
func set_app(workspace_id: int, workspace_app: String, app_name: String, app_path: String, app_icon: String) -> void:
	var ws_key = "workspace %d" % workspace_id
	if not config_data.has(ws_key):
		config_data[ws_key] = {}
	
	config_data[ws_key][workspace_app] = {
		"app_name": app_name,
		"app_path": app_path,
		"app_icon": app_icon
	}
	save_config()

# Remove an app slot entirely
func remove_app(workspace_id: int, workspace_app: String) -> void:
	var ws_key = "workspace %d" % workspace_id

	if config_data.has(ws_key):
		config_data[ws_key].erase(workspace_app)
		save_config()

# Get app info (optional helper)
func get_app(workspace_id: int, workspace_app: String) -> Dictionary:
	var ws_key = "workspace %d" % workspace_id

	if config_data.has(ws_key) and config_data[ws_key].has(workspace_app):
		return config_data[ws_key][workspace_app]
	return {}
