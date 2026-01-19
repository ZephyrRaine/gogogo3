extends Node2D

class_name water_drop_particle 


@onready
var LeftDrop :GPUParticles2D = get_node("WaterDropParticleLateralLeft")
@onready
var RightDrop :GPUParticles2D = get_node("WaterDropParticleLateralRight")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.bounce.connect(_splashParticle)
	EventBus.launch_done.connect(_unsplashParticle)
	pass # Replace with function body.


func _unsplashParticle(_distance: float, _bounces: float) ->void :

	
	LeftDrop.emitting = false;
	
	RightDrop.emitting = false;
	pass

func _splashParticle(_lucky : bool) -> void:

	LeftDrop.emitting = true;
	LeftDrop.restart(false);
	
	RightDrop.emitting = true;
	RightDrop.restart(false);
	pass


func _on_water_drop_particle_lateral_right_finished() -> void:
	LeftDrop.emitting = false;
	pass # Replace with function body.


func _on_water_drop_particle_lateral_left_finished() -> void:
	RightDrop.emitting = false;
	pass # Replace with function body.
