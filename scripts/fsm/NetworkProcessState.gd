class_name NetworkFSMProcessState
extends StateMachineState


# Called when the state machine enters this state.
func on_enter() -> void:
	print("Network Process State entered")


# Called every frame when this state is active.
func on_process(delta: float) -> void:
	get_parent().socket.poll()
	var state = get_parent().socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while get_parent().socket.get_available_packet_count():
			print("Packet: ", get_parent().socket.get_packet())
	


# Called every physics frame when this state is active.
func on_physics_process(delta: float) -> void:
	pass


# Called when there is an input event while this state is active.
func on_input(event: InputEvent) -> void:
	pass


# Called when the state machine exits this state.
func on_exit() -> void:
	print("Network Process State left")
