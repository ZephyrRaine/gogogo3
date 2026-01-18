extends CanvasLayer
class_name HUD

@export var score_label: Label
@export var in_game_score_label: Label
@export var shop: Control
@export var tournament_view : TournamentView

var round_score
var round_rank
var pebble : Pebble

func _ready() -> void:
	EventBus.shop_requested.connect(display_shop)
	EventBus.shop_ended.connect(hide_shop)
	EventBus.scoring_show.connect(display_score)
	EventBus.show_tournament.connect(show_tournament_requested)
	EventBus.start_launch.connect(show_pebble_score)
	EventBus.launch_done.connect(hide_pebble_score)

func show_pebble_score(_pebble:Pebble):
	pebble = _pebble;
	in_game_score_label.visible = true;

func hide_pebble_score(_a, _b):
	pebble = null
	in_game_score_label.visible = false;

func _input(event: InputEvent) -> void:
	if score_label.visible && event.is_action_pressed("interact"):
		score_label.visible = false
		await get_tree().create_timer(0.25).timeout
		EventBus.scoring_done.emit(round_score)

	elif tournament_view.visible && event.is_action_pressed("interact"):
		tournament_view.visible = false
		await get_tree().create_timer(0.25).timeout
		EventBus.hide_tournament.emit()

func _process(_delta: float) -> void:
	if pebble && in_game_score_label.visible:
		in_game_score_label.text = "%d" % [(pebble.position.x - pebble.initial_position.x) * pebble.score_bounces+1]

func display_score(distance: float, bounces: int):
	# Create a context object to calculate the final numbers
	var score_ctx = {"score_distance": distance, "final_score": 0}

	# Apply modifiers (like "Headstart")
	ObjectManager.apply_trigger("on_score", score_ctx)

	var final_dist = score_ctx["score_distance"]

	# Apply the Permanent Multiplier (Bullseye Bonus)
	var multiplier = (bounces + 1) * ObjectManager.permanent_stats["final_score_multiplier"]

	score_label.visible = true
	# Update text logic to use modified values
	round_score = final_dist * multiplier
	score_label.text = "\n%d x %.1f = %d" % [final_dist, multiplier, round_score]


func display_shop(_m):
	shop.visible = true


func hide_shop():
	shop.visible = false

func show_tournament_requested(tournament_data:Dictionary):
	round_rank = tournament_view.display_tournament(tournament_data)
