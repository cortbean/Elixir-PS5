class_name NetworkFSMDisconnectingState
extends StateMachineState


# Called when the state machine enters this state.
func on_enter() -> void:
	print("Network Disconnecting State entered")
	get_parent().current_state = $"../NetworkWaitingState"


# Called every frame when this state is active.
func on_process(delta: float) -> void:
	get_parent().socket.poll()
	var state = get_parent().socket.get_ready_state()
	if state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = get_parent().socket.get_close_code()
		var reason = get_parent().socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		get_node("AspectRatioContainer/GridContainer/btn_Connect").text = "Connect"
		get_node("AspectRatioContainer/GridContainer/lb_ConnectionStatusPackets").text = "Disconnected"
		get_parent().current_state = $"../NetworkWaitingState"


# Called every physics frame when this state is active.
func on_physics_process(delta: float) -> void:
	pass


# Called when there is an input event while this state is active.
func on_input(event: InputEvent) -> void:
	pass


# Called when the state machine exits this state.
func on_exit() -> void:
	print("Network Disconnecting State left")
