extends Node2D

@onready
var speedTrail:GPUParticles2D = get_node("SpeedTrailSFX")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.launch_done.connect(_onlunchdone)
	EventBus.new_launch.connect(_onLunchstart)
	pass # Replace with function body.

func _onLunchstart(_direction:Vector3, _force:float) -> void :
	speedTrail.emitting = true
	speedTrail.restart(true)
	pass

func _onlunchdone(_distance: float, _bounces: int) -> void :
	speedTrail.emitting = false
	speedTrail.restart(true)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
