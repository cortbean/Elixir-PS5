extends RigidBody3D

func _physics_process(delta):
	# Move forward along the Z axis
	apply_central_force(Vector3(0, 0, 0))
