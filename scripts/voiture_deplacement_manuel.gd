extends CharacterBody3D

@export var wheel_base : float = 3.0
@export var steering_angle_deg : float = 90.0
@export var engine_power : float = 2.0
@export var braking_force : float = -2.0
@export var max_reverse_speed : float = 2.0
@export var friction_coeff : float = -30.0
@export var drag_coeff : float = -0.2
@export var slip_speed : float = 20.0
@export var traction_fast : float = 0.2
@export var traction_slow : float = 0.7

var acceleration : Vector3 = Vector3.ZERO
var steer_angle_rad : float = 0.0

func _physics_process(delta: float):
	acceleration = Vector3.ZERO
	_get_input()
	_apply_friction_and_drag(delta)
	_calculate_steering(delta)
	velocity += acceleration * delta
	move_and_slide()

func _get_input():
	var turn = Input.get_action_strength("Left") - Input.get_action_strength("Right")
	steer_angle_rad = deg_to_rad(steering_angle_deg) * turn
	if Input.is_action_pressed("Up"):
		acceleration += -transform.basis.z * engine_power
	elif Input.is_action_pressed("Down"):
		acceleration += -transform.basis.z * braking_force

func _apply_friction_and_drag(delta: float):
	if acceleration == Vector3.ZERO and velocity.length() < 0.5:
		velocity = Vector3.ZERO
	var friction_force = velocity * friction_coeff * delta
	var drag_force = velocity * velocity.length() * drag_coeff * delta
	acceleration += friction_force + drag_force

func _calculate_steering(delta: float):
	var rear_wheel_pos = global_transform.origin + transform.basis.z * (wheel_base * 0.5)
	var front_wheel_pos = global_transform.origin + transform.basis.z * (-wheel_base * 0.5)
	rear_wheel_pos += velocity * delta
	front_wheel_pos += velocity.rotated(Vector3.UP, steer_angle_rad) * delta
	var new_heading = (front_wheel_pos - rear_wheel_pos).normalized()
	var d = 0.0
	if velocity.length() > 0.0:
		d = new_heading.dot(velocity.normalized())
	var traction = traction_fast if velocity.length() > slip_speed else traction_slow
	if d > 0:
		velocity = velocity.lerp(new_heading * velocity.length(), (1.0 - traction) * delta * 2.0)
	elif d < 0:
		velocity = -new_heading * min(velocity.length(), max_reverse_speed)
	look_at(global_transform.origin + new_heading, Vector3.UP)
