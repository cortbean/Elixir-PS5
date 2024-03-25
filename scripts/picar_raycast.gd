extends Node3D

const RAY_LENGTH = 1000
const MAX_PROXIMITY_LENGHT = 0.1

var ray = null
var ray_collision_point = Vector3.ZERO
var distance = 0.0

var target_velocity = Vector3.ZERO
var target_rotation = Vector3.ZERO
const SPEED = -0.09
const SPEED_DIRECTION = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	ray = get_node("RayCast3D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
func _physics_process(delta):
# Ray casting for distance
	if ray.is_colliding():
		ray_collision_point = ray.get_collision_point()
		distance = ray_collision_point.distance_to(position)
		#print(ray_collision_point)
		#print(distance)
	else:
		pass
		
	# Closed loop here
	target_velocity.z = 0.0 * delta 
	print($line_follower_sensor.get_child(0).line_follower_array)
	if $line_follower_sensor.get_child(0).line_follower_array[2] == 0:
		print("Middle")
		#target_velocity.z = 0.0 * delta
	if $line_follower_sensor.get_child(0).line_follower_array[1] == 0:
		print("Middle Left")
		target_velocity.z = SPEED_DIRECTION * -0.5 * delta
	if $line_follower_sensor.get_child(0).line_follower_array[3] == 0:
		print("Middle Right")
		target_velocity.z = SPEED_DIRECTION * 0.5 * delta
	if $line_follower_sensor.get_child(0).line_follower_array[4] == 0:
		print("Right")
		target_velocity.z = SPEED_DIRECTION * 1.0 * delta
	if $line_follower_sensor.get_child(0).line_follower_array[0] == 0:
		print("Left")
		target_velocity.z = SPEED_DIRECTION * -1.0 * delta
		
	if distance < MAX_PROXIMITY_LENGHT:
		target_velocity.x = 0
	else:
		target_velocity.x = SPEED * delta
	
	print(target_velocity)
	position += target_velocity
	#rotation += target_rotation
