class_name NetworkFSMConnectingState
extends StateMachineState


# Called when the state machine enters this state.
func on_enter() -> void:
	print("Network Connecting State entered")
	var result = get_parent().socket.connect_to_url("wss://" + $"../../AspectRatioContainer/GridContainer/le_IpAdress".text)


# Called every frame when this state is active.
func on_process(delta: float) -> void:
	get_parent().socket.poll()
	var state = get_parent().socket.get_ready_state()
	if state == WebSocketPeer.STATE_CONNECTING:
		# Could be nice to have a blinker showing thats it's trying to connect?
		pass
	elif state == WebSocketPeer.STATE_OPEN:
		get_parent().current_state = $"../NetworkProcessState"
		get_node("AspectRatioContainer/GridContainer/btn_Connect").disabled = false
		get_node("AspectRatioContainer/GridContainer/btn_Connect").text = "Disconnect"
		get_node("AspectRatioContainer/GridContainer/lb_ConnectionStatusPackets").text = "Connected!"


# Called every physics frame when this state is active.
func on_physics_process(delta: float) -> void:
	pass


# Called when there is an input event while this state is active.
func on_input(event: InputEvent) -> void:
	pass


# Called when the state machine exits this state.
func on_exit() -> void:
	print("Network Connecting State left")
