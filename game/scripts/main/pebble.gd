extends Node2D
class_name Pebble


@export var initial_position: Vector2
@export var water_height = 93.0

@export var pebble_shadow : Sprite2D

@export_group("Bounces")
@export var bounces_per_launch_force_point = 16 #nombre de rebonds par point de launch_force du lancer (équilibrable)
@export var bounce_length_per_launch_force_point = 800 #taille d'un rebond de lancer par point de launch_force du lancer (équilibrable)
@export var min_bounce_velocity = 0.5
@export var min_bounce_angle = -0.4

@export_group("velocity")
@export var velocity_per_launch_force_point = 1.0 #nvitesse (esthétique) par point de launch_force du lancer
@export var lost_velocity_ratio_on_bounce = 0.9
@export var lost_angle_ratio_on_bounce = 0.9
@export var lost_length_ratio_on_bounce = 0.8

@onready var og_water_height = water_height
@onready var og_min_bounce_velocity = min_bounce_velocity

var height_that_ends = 75.0
var trajectory_that_ends = 0.4

var velocity
var distance
var bounce_angle
var bounce_index
var bounce_length
var total_bounces : int
var max_bounce_length

var score_bounces
var score_distance

var p0 : Vector2
var p1 : Vector2
var p2 : Vector2 
var t = 0.0

var current_bounce_velocity


func _ready() -> void:
	visible = false
	pebble_shadow.visible = false
	pebble_shadow.position.y = water_height
	EventBus.scoring_done.connect(func(): position = initial_position)

func launch_pebble(launch_direction: Vector2, launch_force: float):
	
	print("launch ", launch_force)
	visible = true
	pebble_shadow.visible = true
	position = initial_position

	# RESET STATS TO DEFAULTS FIRST (Important so buffs don't stack infinitely every retry)
	score_bounces = 0
	score_distance = 0.0

	# APPLY PASSIVE & LAUNCH EFFECTS
	ObjectManager.apply_trigger("passive", self)
	ObjectManager.apply_trigger("on_launch", self)

	
	velocity = launch_force * velocity_per_launch_force_point
	total_bounces = int(launch_force * bounces_per_launch_force_point)
	print("total bounces: ", total_bounces)
	max_bounce_length = launch_force * bounce_length_per_launch_force_point
	
	distance = 0
	bounce_index = 0
	bounce_angle = launch_direction.angle()
	bounce_length = max_bounce_length
	start_bounce()

func start_bounce():
	p0 = position
	p2.x = p0.x + bounce_length
	p2.y = water_height
	
	p1.x = (p0.x + p2.x) * 0.5
	p1.y = water_height + (p2.x - p0.x) * tan(bounce_angle)
	t = 0.0
	print("height ", p1.y)
	print("ratio ", -((p2.x - p0.x) * tan(bounce_angle)) / (p2.x - p0.x))
	
	if (bounce_index > 0
	&& (p1.y > height_that_ends || -((p2.x - p0.x) * tan(bounce_angle)) / (p2.x - p0.x) > trajectory_that_ends)):
		launch_over()
	else:
		distance += p2.x - p0.x
		score_distance += p2.x - p0.x # possible modifier here

func end_bounce():
	# HANDLE BOUNCE COUNT LOGIC
	var bounce_ctx = {"bounce_count_amount": 1} # Default is 1
	ObjectManager.apply_trigger("on_bounce_count", bounce_ctx)
	score_bounces += bounce_ctx["bounce_count_amount"]
	bounce_index = bounce_index + 1
	
	# HANDLE BOUNCE PHYSICS 
	# var physics_ctx = {"velocity_y": velocity}
	# ObjectManager.apply_trigger("on_bounce_physics", physics_ctx)
	# velocity = physics_ctx["velocity_y"]
	velocity *= lost_velocity_ratio_on_bounce
	bounce_angle *= lost_angle_ratio_on_bounce
	bounce_length *= lost_length_ratio_on_bounce
	#print("angle: ", bounce_angle)
	if(bounce_angle > -0.1): bounce_angle = -0.1
	start_bounce()

func launch_over():
	visible = false
	pebble_shadow.visible = false
	EventBus.launch_done.emit(score_distance, score_bounces)
	

func _process(delta: float) -> void:
	if !visible:
		return
	
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	position = q0.lerp(q1, t)
	pebble_shadow.position.x = position.x
	t+=delta*velocity*(max_bounce_length/bounce_length)
		
	if (t >= 1.0 || position.y > water_height): 
		position.y = water_height
		end_bounce()
