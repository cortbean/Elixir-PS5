class_name NetworkFSMProcessState
extends StateMachineState

var data_to_send = {"up": 0.0,"down": 0.0, "left": 0.0, "right": 0.0}

func _input(event):
	if event is InputEventKey:
		if event.is_pressed():
			if event.keycode == KEY_UP:
				data_to_send["up"] = 1.0
			if event.keycode == KEY_DOWN:
				data_to_send["down"] = 1.0
			if event.keycode == KEY_LEFT:
				data_to_send["left"] = 1.0
			if event.keycode == KEY_RIGHT:
				data_to_send["right"] = 1.0
		if event.is_released():
			if event.keycode == KEY_UP:
				data_to_send["up"] = 0.0
			if event.keycode == KEY_DOWN:
				data_to_send["down"] = 0.0
			if event.keycode == KEY_LEFT:
				data_to_send["left"] = 0.0
			if event.keycode == KEY_RIGHT:
				data_to_send["right"] = 0.0

# Called when the state machine enters this state.
func on_enter() -> void:
	print("Network Process State entered")
	#get_parent().socket.send_text("Hello mom!")


# Called every frame when this state is active.
func on_process(delta: float) -> void:
	get_parent().socket.poll()
	var state = get_parent().socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:

# Received packets and process them
		while get_parent().socket.get_available_packet_count():
			var err = JSON.parse_string(get_parent().socket.get_packet().get_string_from_utf8())
			if err:
				print(err)

# Send current data to send JSON packet
		var json_data = JSON.stringify(data_to_send).to_utf8_buffer()
		get_parent().socket.send(json_data)
	elif state == WebSocketPeer.STATE_CLOSING || WebSocketPeer.STATE_CLOSING:
		get_parent().current_state = $"../NetworkDisconnectingState"


# Called every physics frame when this state is active.
func on_physics_process(delta: float) -> void:
	pass


# Called when there is an input event while this state is active.
func on_input(event: InputEvent) -> void:
	pass


# Called when the state machine exits this state.
func on_exit() -> void:
	print("Network Process State left")
