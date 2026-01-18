extends Node2D

class_name water_drop_particle 

@onready
var UpperDrop :GPUParticles2D = get_node("WaterDropParticle")
@onready
var LeftDrop :GPUParticles2D = get_node("WaterDropParticleLateralLeft")
@onready
var RightDrop :GPUParticles2D = get_node("WaterDropParticleLateralRight")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.bounce.connect(_splashParticle)
	pass # Replace with function body.


func _splashParticle() -> void:
	UpperDrop.emitting = true;
	LeftDrop.emitting = true;
	RightDrop.emitting = true;
	pass 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
