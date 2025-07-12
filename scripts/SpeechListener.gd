extends Node

var server := UDPServer.new()
var peers: Array = []
var last_text: String = ""
var message_number = 0
var message = {}

var speech_process_id = -1

var args = []

var voice_mode : bool = false
var listener_ready : bool = false
var client_active : bool = false


var DIR = OS.get_executable_path().get_base_dir()
var exe_path = "res://bin/speech_client.exe"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		
		
	var result = server.listen(4242)
	if result != OK:
		print("Failed to bind UDP server!")
	else:
		print("UDP server listening on port 4242")


func start_client(exe_path) -> void:
	if OS.has_feature("windows"):
		var output = OS.execute_with_pipe(exe_path,args)   ### ths function is new to godot 4.3 and 4.4 and is not available in lower versions ###
		speech_process_id = output["pid"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if !OS.has_feature("standalone") and voice_mode and !client_active:
		exe_path = ProjectSettings.globalize_path("res://bin/speech_client.exe")
		start_client(exe_path)
		client_active = true
	
	server.poll()  # must call this every frame!

	# Accept new peer connections
	if server.is_connection_available():
		var peer = server.take_connection()
		peers.append(peer)
		print("New peer added: %s:%s" % [peer.get_packet_ip(), peer.get_packet_port()])

	# Poll all known peers for incoming packets
	for peer in peers:
		while peer.get_available_packet_count() > 0:
			var packet = peer.get_packet()
			var msg = packet.get_string_from_utf8()
			listener_ready = true
			#print("Received from %s:%s → %s" % [peer.get_packet_ip(), peer.get_packet_port(), msg])
			last_text = msg
			message_number += 1
			#print(message_number)
			message = {"Number": message_number, "Message" : last_text}
			# Optional: Echo back
			peer.put_packet(packet)
	
	
func get_latest_speech():
	return message
	#
#exit tree function
func _exit_tree():
	print(speech_process_id)
	if OS.has_feature("windows") and speech_process_id != -1:
		OS.kill(speech_process_id)
		

func kill_process(pid):
	if OS.has_feature("windows") and pid != -1:
		OS.kill(pid) 
		
		
"""ALTERNATIVE WAY OF GETTING PIDs"""
func get_all_pids_by_exe_name(exe_name: String) -> Array:
	var output := []
	var cmd := "tasklist /FI \"IMAGENAME eq %s\" /FO CSV /NH" % exe_name
	var exit_code := OS.execute("cmd", ["/C", cmd], output, true)

	var pids := []

	for line in output:
		if line.strip_edges() == "":
			continue
		var parts = line.split(",")
		if parts.size() >= 2:
			var pid_str = parts[1].strip_edges().replace("\"", "")
			var pid = pid_str.to_int()
			if pid > 0:
				pids.append(pid)
	return pids
