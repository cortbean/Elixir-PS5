extends Area3D


@export var line_follower_array: PackedByteArray = [0,0,0,0,0]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Si vous voulez voir l'état même sans entrée/sortie (pour le débogage)
	# print("Actuel: %s" % line_follower_array)
	pass
	
#func _physics_process(delta):
	#var bodies = get_overlapping_bodies()
	#
	#for i in range(line_follower_array.size()):
		#line_follower_array[i] = 0
	#
	##for i in range(get_child_count()):
		##var sensor = get_child(i)
	##
	#for i in range(bodies.size()):
		#var body = bodies[i]
		#if body.collision_layer == 2:
			#line_follower_array[i] = 1
					#
	#print("État des capteurs: %s" % line_follower_array)
	
func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):	
	if body.collision_layer == 2:
		line_follower_array[local_shape_index] = 1
		#
		# print("--- DÉTECTION ENTRÉE ---")
		# print("Capteur #%s ACTIF" % local_shape_index)
		print("État des capteurs (Array): %s" % line_follower_array)
		


func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.collision_layer == 2:
		line_follower_array[local_shape_index] = 0
		
		# Vous pouvez aussi décommenter cette ligne pour vérifier que la sortie fonctionne
		# print("Capteur #%s DÉSACTIVÉ. État : %s" % [local_shape_index, line_follower_array])


func _on_area_exited(area: Area3D) -> void:
	pass # Replace with function body.
