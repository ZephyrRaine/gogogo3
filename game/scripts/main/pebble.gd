extends Node2D
class_name Pebble

@export var bounces_per_force_point = 16 #nombre de rebonds par point de force du lancer (équilibrable)
@export var bounce_length_per_force_point = 100 #taille d'un rebond par point de force du lancer (équilibrable)

@export var speed_per_force_point = 1.0 #nvitesse (esthétique) par point de force du lancer

@export var initial_position: Vector2
@export var initial_speed = 1.0

@export var water_height = 93.0
@export var min_bounce_velocity = 10

@onready var og_initial_speed = initial_speed
@onready var og_gravity = gravity
@onready var og_bounce_ratio = bounce_ratio
@onready var og_friction_y = friction_y
@onready var og_friction_x = friction_x
@onready var og_water_height = water_height
@onready var og_min_bounce_velocity = min_bounce_velocity

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
	speed = initial_speed * force
	velocity = direction * speed

	# RESET STATS TO DEFAULTS FIRST (Important so buffs don't stack infinitely every retry)
	gravity = og_gravity
	bounce_ratio = og_bounce_ratio
	initial_speed = og_initial_speed # Or whatever your default is

	# APPLY PASSIVE & LAUNCH EFFECTS
	ObjectManager.apply_trigger("passive", self)
	ObjectManager.apply_trigger("on_launch", self)

	direction = _direction
	speed = initial_speed * force # Now uses the modified initial_speed
	velocity = direction * speed

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

	velocity.y += gravity * delta
	#velocity.y *= friction_y
	#velocity.x *= friction_x
	position += velocity * delta
	distance = position.x - initial_position.x
	if position.y > water_height:
		if velocity.y > min_bounce_velocity:
			# HANDLE BOUNCE COUNT LOGIC
			var bounce_ctx = {"bounce_count_amount": 1} # Default is 1
			ObjectManager.apply_trigger("on_bounce_count", bounce_ctx)
			bounces += bounce_ctx["bounce_count_amount"]

			velocity.y *= -bounce_ratio

			# HANDLE BOUNCE PHYSICS (e.g. Chaos Spring)
			# We modify velocity.y directly here.
			# Since we just flipped it to negative (upward), multiplying by 2 makes it go higher.
			var physics_ctx = {"velocity_y": velocity.y}
			ObjectManager.apply_trigger("on_bounce_physics", physics_ctx)
			velocity.y = physics_ctx["velocity_y"]
			position.y = water_height - 0.1
		else:
			visible = false
			EventBus.launch_done.emit(distance, bounces)
