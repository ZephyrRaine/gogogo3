extends Node2D
class_name GameManager

@export var launch_manager: LaunchManager
@export var pebble: Pebble


func _ready() -> void:
	EventBus.new_launch.connect(received_launch)
	EventBus.scoring_done.connect(scoring_done)
	EventBus.shop_ended.connect(launch_manager.request_launch)
	launch_manager.request_launch()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()


func scoring_done():
	EventBus.shop_requested.emit()

#TODO: make it so straight launches are better than up launches lol
func received_launch(aim_percentage: float, force_percentage: float):
	pebble.launch_pebble(
		Vector2(1, lerp(0.70, -0.70, aim_percentage + 0.5)).normalized(),
		10 * (1 - abs(aim_percentage * 0.5)) * force_percentage
	)
