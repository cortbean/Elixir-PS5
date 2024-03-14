extends Node3D

const RAY_LENGTH = 1000
var ray = 0
var ray_collision_point = Vector3(0,0,0)
var distance = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	ray = get_node("RayCast3D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if ray.is_colliding():
		ray_collision_point = ray.get_collision_point()
		print(ray_collision_point)
		distance = ray_collision_point.distance_to(position)
		print(distance)
	else:
		#print("aww shit")
		pass


func _on_front_line_sensor_collider_body_entered(body):
	print(body)
