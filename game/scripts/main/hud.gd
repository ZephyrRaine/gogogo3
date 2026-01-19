extends CanvasLayer
class_name HUD

@export var score_root:Control
@export var score_total_root:Control
@export var score_total_label: Label
@export var score_dist_label : Label
@export var score_bounce_label : Label
@onready var shop: Control = $"SHOP"
@export var tournament_view : TournamentView

@export var effects_manager:EffectsManager

var round_score:int
var round_rank
var pebble : Pebble

var final_score_displayed = false

func _ready() -> void:
	EventBus.shop_requested.connect(display_shop)
	EventBus.shop_ended.connect(hide_shop)
	EventBus.scoring_show.connect(display_score)
	EventBus.show_tournament.connect(show_tournament_requested)
	EventBus.start_launch.connect(on_start_launch)
	EventBus.launch_done.connect(on_launch_done)


func on_start_launch(_pebble:Pebble):
	pebble = _pebble;
	effects_manager.pebble = pebble
	score_root.visible = true
	score_total_root.visible = false

func on_launch_done(_a, _b):
	pebble = null
	score_total_root.visible = true
	score_total_label.text = "%d" % [(int)(_a * _b)]

func _input(event: InputEvent) -> void:
	if final_score_displayed && event.is_action_pressed("interact"):
		score_root.visible = false
		final_score_displayed = false
		await get_tree().create_timer(0.25).timeout
		EventBus.scoring_done.emit(round_score)

	elif tournament_view.visible && event.is_action_pressed("interact"):
		tournament_view.visible = false
		await get_tree().create_timer(0.25).timeout
		EventBus.hide_tournament.emit()

func _process(_delta: float) -> void:
	if pebble:
		score_bounce_label.text = "%d" % [pebble.score_bounces]
		score_dist_label.text = "%d" % [pebble.score_distance]

func display_score(distance: float, bounces: int):
	# Create a context object to calculate the final numbers
	var score_ctx = {"speed_score": distance, "splash_score": bounces, "final_score": 0}

	# Apply modifiers (like "Headstart")
	ObjectManager.apply_trigger("on_score", score_ctx)

	var final_speed_score = score_ctx["speed_score"]
	var final_splash_score = score_ctx["splash_score"]

	# Apply the Permanent Multiplier (Bullseye Bonus)
	var multiplier = (final_splash_score) * ObjectManager.permanent_stats["final_score_multiplier"]

	score_root.visible = true
	# Update text logic to use modified values
	round_score = final_speed_score * multiplier
	score_ctx["final_score"] = round_score
	ObjectManager.apply_trigger("on_score", score_ctx)
	round_score = score_ctx["final_score"]
	print(round_score)
	score_total_label.text = "%d" % [round_score]
	score_bounce_label.text = "%d" % [multiplier]
	score_dist_label.text = "%d" % [final_speed_score]
	
	final_score_displayed = true


func display_shop(_m):
	shop.visible = true


func hide_shop():
	shop.visible = false

func show_tournament_requested(tournament_data:Dictionary):
	round_rank = tournament_view.display_tournament(tournament_data)
