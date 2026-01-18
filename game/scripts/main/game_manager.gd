extends Node2D
class_name GameManager

@export var launch_manager: LaunchManager
@export var pebble: Pebble

var current_day = 0;
var current_round = -1;
var current_score = 0;
var game_started = false;

func _ready() -> void:
	EventBus.new_launch.connect(received_launch)
	EventBus.scoring_done.connect(scoring_done)
	EventBus.launch_done.connect(launch_done)
	EventBus.shop_ended.connect(launch_manager.request_launch)
	EventBus.hide_tournament.connect(tournament_closed)

	EventBus.show_tournament.emit(current_day, current_round, current_score)

func tournament_closed(rank):
	if current_round == 2:
		if rank == 7:
			get_tree().reload_current_scene()
			return

		current_day += 1
		current_round = 0
		EventBus.shop_requested.emit()
	else:
		current_round += 1
		launch_manager.request_launch()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()

func launch_done(distance:float, bounces:int):
	EventBus.scoring_show.emit(distance, bounces)

func scoring_done(round_score):
	current_score += round_score;
	EventBus.show_tournament.emit(current_day, current_round, current_score)

#TODO: make it so straight launches are better than up launches lol
func received_launch(aim_percentage: float, force_percentage: float):
	if abs(aim_percentage) <= 0.05:
		print("Perfect Aim!")
		ObjectManager.apply_trigger("on_perfect_aim", self)


	pebble.launch_pebble(
		Vector2(1, lerp(0.70, -0.70, aim_percentage + 0.5)).normalized(),
		(1 - abs(aim_percentage * 0.5)) * force_percentage
	)
