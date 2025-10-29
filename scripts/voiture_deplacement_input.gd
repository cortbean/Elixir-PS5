extends CharacterBody3D

@onready var line_detector = $line_follower/sensor_array

# Rotation
var rayon: float = 1.0
var vitesse_angulaire: float = 0.0
var acceleration: float = 0.73575
var angle: float = 0.0
var vitesse_maximale: float = 1.0
var rotationne: bool = false

var centre: Vector3 = Vector3.ZERO
var centre_defini: bool = false
var tourne_gauche: bool = true 

# Reculons
var distance_recul_max: float = 0.2 # en mètres
var recule: bool = false
var distance_parcourue: float = 0.0
var vitesse: float = 0.0
var position_depart: Vector3

# Avancer
var avancer: bool = false

func _physics_process(delta: float):
	_get_input(delta)
	_rotation_angle(delta)
	_reculer(delta, 0.2)
	_avancer(delta)

func _get_input(delta:float):
	if Input.is_action_just_released("Up"):
		rotationne = true
	if Input.is_action_just_released("Down"):
		rotationne = false
	if Input.is_action_just_released("Left"):
		_demarrer_recul(distance_recul_max)
	if Input.is_action_just_pressed("Right"):
		avancer = not avancer
	if Input.is_action_pressed("Tourner"):
		_ajouter_angle(delta, 5.0)
	if Input.is_action_pressed("Follow"):
		_suivre_ligne(delta)
		_avancer(delta)

func _rotation_angle(delta:float) -> void:
	if rotationne:
		if not centre_defini:
			var direction_droite: Vector3 = -transform.basis.z.normalized()
			var sens: float = -1.0 if tourne_gauche else 1.0
			centre = global_position + direction_droite * (rayon * sens)
			
			var posi_actuelle: Vector3 = global_position - centre
			angle = atan2(posi_actuelle.z, posi_actuelle.x)
			
			centre_defini = true
		
		if vitesse_angulaire < vitesse_maximale:
			vitesse_angulaire += acceleration * delta
			vitesse_angulaire = min(vitesse_angulaire, vitesse_maximale)
		_effectuer_rotation(delta, true)
	else :
		if vitesse_angulaire > 0.0:
			vitesse_angulaire -= acceleration * delta
			vitesse_angulaire = max(vitesse_angulaire, 0.0)
			_effectuer_rotation(delta, true)
		else:
			centre_defini = false

func _effectuer_rotation(delta:float, gauche:bool):
	var sens: float = -1.0 if tourne_gauche else 1.0
	angle += sens * vitesse_angulaire * delta
	
	# Faire la rotation de la voiture sur un axe
	var x = centre.x + rayon * cos(angle)
	var z = centre.z + rayon * sin(angle)
	global_position.x = x
	global_position.z = z
	
	look_at(Vector3(centre.x, global_position.y, centre.z))
	var look_deg: float = 0.0 if not tourne_gauche else 180.0 
	rotate_y(deg_to_rad(look_deg))

func _demarrer_recul(distance: float) -> void:
	distance_recul_max = distance
	position_depart = global_position
	distance_parcourue = 0.0
	vitesse = 0.0
	recule = true

func _reculer(delta: float, distance_recul:float) -> void:
	if not recule:
		return

	# Distance parcourue actuelle
	distance_parcourue = global_position.distance_to(position_depart)
	var distance_restante = distance_recul - distance_parcourue

	# Calcul de la distance de freinage actuelle
	var distance_freinage = (vitesse * vitesse) / (2.0 * acceleration)

	if distance_restante <= 0.0:
		recule = false
		vitesse = 0.0
		return

	if distance_restante <= distance_freinage:
		vitesse -= acceleration * delta
	else:
		vitesse += acceleration * delta
	vitesse = clamp(vitesse, 0.0, vitesse_maximale)

	var deplacement = transform.basis.x * vitesse * delta
	if distance_parcourue + deplacement.length() > distance_recul:
		var distance_reste = distance_recul - distance_parcourue
		deplacement = transform.basis.x * distance_reste
		recule = false
		vitesse = 0.0

	global_translate(deplacement)

func _avancer(delta:float) -> void:
	if avancer:
		if vitesse < vitesse_maximale:
			vitesse += acceleration * delta
			vitesse = min(vitesse, vitesse_maximale)
		var deplacement = -transform.basis.x * vitesse * delta
		global_translate(deplacement)
	else :
		if vitesse > 0.0 and not recule:
			vitesse -= acceleration * delta
			vitesse = max(vitesse, 0.0)
			var deplacement = -transform.basis.x * vitesse * delta
			global_translate(deplacement)

func _ajouter_angle(delta:float, angle:float, vitesse_rotation: float = 90.0) -> void:
	if avancer and angle != 0:
		var rotation = sign(angle) * vitesse_rotation * delta
		
		if abs(rotation) > abs(angle):
			rotation = angle
		rotate_y(deg_to_rad(rotation))
		
func _suivre_ligne(delta: float) -> void:
	var sensor = line_detector.line_follower_array
	
	if sensor[2] == 1:
		avancer = true
		rotationne = false
	elif sensor[0] == 1 :
		avancer = true
		rotationne = true
		tourne_gauche = true
		_ajouter_angle(delta, 100, 360)
	elif sensor[1] == 1:
		avancer = true
		rotationne = true
		tourne_gauche = true
		_ajouter_angle(delta, 30, 360)
	elif sensor[3] == 1:
		avancer = true
		rotationne = true
		tourne_gauche = false
		_ajouter_angle( delta, 30, 360)
	elif sensor[4] == 1:
		avancer = true
		rotationne = true
		tourne_gauche = false
		_ajouter_angle(delta, 100, 360)
	else:
		avancer = false
		rotationne = false
	
	
