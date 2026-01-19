extends Node2D
class_name GameManager

@export var launch_manager: LaunchManager
@export var pebble: Pebble

var current_day = 0;
var current_round = -1;
var current_score = 0;
var game_started = false;

var goals =[850, 750, 650, 550, 450, 350, 250]
var gains = [5, 4, 3, 2, 1, 1, 1, -1]

var money = 0

func get_rank(scores: Array, player_score: int) -> int:
	for i in range(scores.size()):
		if player_score >= scores[i]:
			return i

	return scores.size()

func compute_tournament_dict():
	var tournament_dict = {
		"day_index": current_day,
		"round_index": current_round,
		"player_score": current_score,
		"goals" : goals,
		"gains" : gains,
		"rank_index": get_rank(goals, current_score)
	}
	return tournament_dict


func _ready() -> void:
	EventBus.new_launch.connect(received_launch)
	EventBus.scoring_done.connect(scoring_done)
	EventBus.launch_done.connect(launch_done)
	EventBus.shop_ended.connect(launch_manager.request_launch)
	EventBus.hide_tournament.connect(tournament_closed)
	EventBus.spend_money.connect(spend_money)
	EventBus.show_tournament.emit(compute_tournament_dict())

func spend_money(_previous_money:int, new_money:int):
	money = new_money

func tournament_closed():
	var current_rank = get_rank(goals, current_score)
	if current_round == 2:
		if current_rank == 7:
			get_tree().reload_current_scene()
			return

		current_day += 1
		current_round = 0
		money += gains[current_rank]

		EventBus.shop_requested.emit(money)
	else:
		current_round += 1
		launch_manager.request_launch()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()

	if event.is_action_pressed("debug_speedup"):
		Engine.time_scale = 5;
	if event.is_action_released("debug_speedup"):
		Engine.time_scale = 1;

func launch_done(distance:float, bounces:int):
	EventBus.scoring_show.emit(distance, bounces)

func scoring_done(round_score):
	current_score += round_score;
	EventBus.show_tournament.emit(compute_tournament_dict())

#TODO: make it so straight launches are better than up launches lol
func received_launch(aim_percentage: float, force_percentage: float):
	if abs(aim_percentage) <= 0.05:
		print("Perfect Aim!")
		ObjectManager.apply_trigger("on_perfect_aim", self)


	pebble.launch_pebble(
		Vector2(1, lerp(0.70, -0.70, aim_percentage + 0.5)).normalized(),
		(1 - abs(aim_percentage * 0.5)) * force_percentage
	)
