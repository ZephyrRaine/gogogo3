extends GPUParticles2D

var currentPebble:Pebble
var maxLifetime:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.start_launch.connect(track_pebble)
	pass # Replace with function body.

func track_pebble(_pebble):
	currentPebble = _pebble
	maxLifetime = 4
	print(_pebble)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#lifetime = maxLifetime * currentPebble.current_bounce_velocity
	if(currentPebble):
		amount_ratio = inverse_lerp(0,currentPebble.max_bounce_length,currentPebble.bounce_length)
	pass
