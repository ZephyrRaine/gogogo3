extends Node2D
class_name Pebble

@export var bounces_per_force_point = 16 #nombre de rebonds par point de force du lancer (équilibrable)
@export var bounce_length_per_force_point = 100 #taille d'un rebond par point de force du lancer (équilibrable)

@export var speed_per_force_point = 1.0 #nvitesse (esthétique) par point de force du lancer

@export var initial_position: Vector2
@export var initial_speed = 1.0

@export var water_height = 93.0
@export var min_bounce_velocity = 10

var direction: Vector2
var speed: float
var velocity: Vector2

var distance
var bounce_index
var total_bounces
var max_bounce_length

var p0 : Vector2
var p1 : Vector2
var p2 : Vector2 
var t = 0.0


func _ready() -> void:
	visible = false
	EventBus.scoring_done.connect(func(): position = initial_position)

func launch_pebble(_direction: Vector2, force: float):
	visible = true
	position = initial_position
	direction = _direction
	speed = speed_per_force_point
	
	total_bounces = force * bounces_per_force_point
	print("total bounces: %s", total_bounces)
	max_bounce_length = force * bounce_length_per_force_point
	
	distance = 0
	bounce_index = 0
	
	start_bounce()

func start_bounce():
	p0 = position
	p2.x = p0.x + max_bounce_length
	p2.y = water_height
	
	p1.x = (p0.x + p2.x) * 0.5
	p1.y = water_height + (p2.x - p0.x) * tan(direction.angle())
	t = 0.0

func end_bounce():
	if (bounce_index < total_bounces):
		bounce_index = bounce_index + 1
		start_bounce()
	else:
		launch_over()

func launch_over():
	visible = false
	EventBus.launch_done.emit(distance, total_bounces)
	

func _process(delta: float) -> void:
	if !visible:
		return
