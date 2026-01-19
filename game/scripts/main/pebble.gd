extends Node2D
class_name Pebble


@export var initial_position: Vector2
@export var water_height = 93.0

@export var pebble_shadow : Sprite2D

@export_group("Bounces")
@export var juicy_velocity_curve : Curve
@export var bounce_length_per_launch_force_point = 800 #taille d'un rebond de lancer par point de launch_force du lancer (équilibrable)
@export var min_bounce_velocity = 0.5
@export var min_bounce_angle = -0.4
@export var lucky_bounce_probability = 0.05

@export_group("Friction")
@export var lost_angle_ratio_on_bounce = 0.98
@export var lost_length_ratio_on_bounce = 0.8

@export_group("velocity (no gameplay)")
@export var velocity_per_launch_force_point : Curve #vitesse (esthétique) par point de launch_force du lancer

@onready var og_water_height = water_height
@onready var og_min_bounce_velocity = min_bounce_velocity
@onready var og_lucky_bounce_probability = lucky_bounce_probability

var height_that_ends = 65.0
var trajectory_that_ends = 0.4

var velocity
var distance
var bounce_angle
var bounce_index
var bounce_length
var total_bounces : int
var max_bounce_length

var bad_angle_launch_lost # lost due to a bad launch angle
var ideal_angle_launch = -0.2

var score_bounces
var score_distance

var p0 : Vector2
var p1 : Vector2
var p2 : Vector2
var t = 0.0

var current_bounce_velocity
var current_bounce_is_eagle


func _ready() -> void:
	visible = false
	pebble_shadow.visible = false
	pebble_shadow.position.y = water_height
	EventBus.scoring_done.connect(func(_score): position = initial_position)

func launch_pebble(launch_direction: Vector2, launch_force: float):
	EventBus.start_launch.emit(self)
	visible = true
	pebble_shadow.visible = true
	position = initial_position

	# RESET STATS TO DEFAULTS FIRST (Important so buffs don't stack infinitely every retry)
	score_bounces = 0
	score_distance = 0.0
	lucky_bounce_probability = og_lucky_bounce_probability

	# APPLY PASSIVE & LAUNCH EFFECTS
	ObjectManager.apply_trigger("passive", self)
	ObjectManager.apply_trigger("on_launch", self)


	velocity = velocity_per_launch_force_point.sample(launch_force)
	max_bounce_length = launch_force * bounce_length_per_launch_force_point

	distance = 0
	bounce_index = 0
	bounce_angle = launch_direction.angle()
	bounce_length = max_bounce_length

	bad_angle_launch_lost = abs(angle_difference(bounce_angle, ideal_angle_launch))
	
	start_bounce()

func start_bounce():
	p0 = position
	p2.x = p0.x + bounce_length
	p2.y = water_height

	p1.x = (p0.x + p2.x) * 0.5
	p1.y = water_height + (p2.x - p0.x) * tan(bounce_angle)
	t = 0.0

	if (bounce_index > 0
	&& (p1.y > height_that_ends || -((p2.x - p0.x) * tan(bounce_angle)) / (p2.x - p0.x) > trajectory_that_ends)):
		launch_over()
	else:
		distance += p2.x - p0.x

func end_bounce():
	# HANDLE BOUNCE COUNT LOGIC
	var bounce_ctx = {"bounce_count_amount": 1} # Default is 1
	ObjectManager.apply_trigger("on_bounce_count", bounce_ctx)

	# HANDLE BOUNCE PHYSICS

	#On passe un dictionaire "contexte" avec toutes les variables qui nous intéressent sur le trigger
	var bounce_physics_ctx = {"lost_length_ratio_on_bounce": lost_length_ratio_on_bounce}
	#L'object manager va appeler tous les objets qui ont le trigger en question,
	# vont regarder si l'objet passé en param (en l'occurence le dictionnaire) voir s'il a la stat en question,
	# et appliquer l'opération définie, s'il y a une chance de proc ça le fait que si le lancer de dé est réussi
	# bien vérifier le nom du trigger et le nom de la stat dans objects.json
	#{ "trigger": "on_bounce_physics", "stat": "lost_length_ratio_on_bounce", "op": "mul", "value": 0.5, "chance": 0.2 }
	ObjectManager.apply_trigger("on_bounce_physics", bounce_physics_ctx)

	var is_lucky_bounce = randf() <= lucky_bounce_probability
	if !is_lucky_bounce :
		bounce_angle *= lost_angle_ratio_on_bounce
		#on récupère la variable dans le dictionnaire, si on n'a pas l'item ou si la proba a pas proc c'est la même qu'on a mise
		bounce_length *= bounce_physics_ctx["lost_length_ratio_on_bounce"] - bad_angle_launch_lost
	else:
		ObjectManager.apply_trigger("on_lucky_bounce", bounce_ctx)

	if(bounce_angle > -0.1): bounce_angle = -0.1
	
	#eagle bounce
	var eagle_width_boost = 0.0
	ObjectManager.apply_trigger("eagle_width_boost", eagle_width_boost)
	current_bounce_is_eagle = eagle_width_boost > 0.00001
	if current_bounce_is_eagle :
		bounce_length += eagle_width_boost

	EventBus.bounce.emit(is_lucky_bounce)

	score_bounces += bounce_ctx["bounce_count_amount"]
	bounce_index = bounce_index + 1

	start_bounce()

func launch_over():
	visible = false
	pebble_shadow.visible = false
	EventBus.launch_done.emit(score_distance, score_bounces)


func _process(delta: float) -> void:
	if !visible:
		return

	
	var juiced_t = juicy_velocity_curve.sample(t)
	var q0 = p0.lerp(p1, juiced_t)
	var q1 = p1.lerp(p2, juiced_t)
	position = q0.lerp(q1, juiced_t)
	pebble_shadow.position.x = position.x
	
	t += delta * velocity
	
	score_distance = position.x * 0.1 # divided by 10 to balance

	if (t >= 1.0 || position.y > water_height):
		position.y = water_height
		end_bounce()
