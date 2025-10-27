extends Node3D

# Reference to sensors
@onready var sensor_left = $LeftSensor
@onready var sensor_center = $CenterSensor
@onready var sensor_right = $RightSensor

# Reference to light
var light = null

# Sensor readings (0-255, where lower = brighter)
var A0 = 255  # Left sensor
var A1 = 255  # Center sensor
var A2 = 255  # Right sensor

func _ready():
	# Finds the light in the scene
	var lights = get_tree().get_nodes_in_group("lights")
	if lights.size() > 0:
		light = lights[0]
		print("Light found: ", light.name)
		print("Light position: ", light.global_position)
	else:
		print("Warning: No light found! Add your OmniLight3D to the 'lights' group")

func _process(delta):
	# Update sensor readings every frame
	if light != null:
		A0 = read_light_sensor(sensor_left)
		A1 = read_light_sensor(sensor_center)
		A2 = read_light_sensor(sensor_right)

		print([A0, A1, A2])

func read_light_sensor(sensor):
	# Calculate distance from sensor to light
	var sensor_pos = sensor.global_position
	var light_pos = light.global_position
	var distance = sensor_pos.distance_to(light_pos)
	
	# Get the light's properties
	var light_energy = light.light_energy
	var light_range = light.omni_range
	
	# if sensor == sensor_left:
		# print("Distance to light left: ", distance, " | Light energy: ", light_energy)
	# if sensor == sensor_center:
		# print("Distance to light center: ", distance, " | Light energy: ", light_energy)
	# if sensor == sensor_right:
		# print("Distance to light right: ", distance, " | Light energy: ", light_energy)

	# Calculate intensity (inverse square law)
	var intensity = (light_energy) / (distance * distance + 0.1)
	
	# Clamp to avoid extreme values
	intensity = clamp(intensity, 0, 50)
	print("Intensity: ", intensity)
	
	# Convert to 0-255 scale
	var reading = 255 - (intensity / 50.0) * 255
	
	return int(reading)
