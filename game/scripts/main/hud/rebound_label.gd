class_name ReboundLabel
extends Label

@export var anim_curve_y:Curve
@export var anim_amplitude = Vector2(0.0, -80.0)
@export var scale_amplitude = Vector2(2.0, 2.0)
@export var anim_speed = 2
var t:float
var pos_0:Vector2
var pos_1:Vector2
var scale_0:Vector2

var offset = Vector2(0.0, -50.0)

func _ready() -> void:
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (visible==false):
		return

	t += delta * anim_speed
	var sample = anim_curve_y.sample(t)
	global_position = pos_0.lerp(pos_1, sample)
	scale = scale_0.lerp(scale_0 * scale_amplitude, sample)
	
	if (t >= 1.0):
		visible = false
		scale = scale_0

func start_anim(start_pos:Vector2):
	scale_0 = scale
	pos_0 = start_pos + offset
	pos_1 = pos_0 + anim_amplitude
	global_position = pos_0
	t = 0.0
	visible = true
