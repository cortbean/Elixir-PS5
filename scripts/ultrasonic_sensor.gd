extends Node3D

func _process(delta):
	print(get_distance())

func get_distance():
	if $RayCast3D.is_colliding():
		var origin = $RayCast3D.global_transform.origin
		var collision_point = $RayCast3D.get_collision_point()
		var distance = origin.distance_to(collision_point)
		return distance
	else:
		return null
