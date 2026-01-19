extends Node
class_name LaunchHud

@export_group("Date")
@export var date_root:Control
@export var date_day:Label
@export var date_separator:Label
@export var date_round:Label

@export_group("Score")
@export var score_root:Control
@export var score_total_root:Control
@export var score_total_label: Label
@export var score_dist_label : Label
@export var score_bounce_label : Label

var score_dist_previous:int
var score_bounce_previous:int
var score_total:int

func display_date(day_index:int, round_index:int, round_total:int):
	date_day.text = "DAY %s" % [day_index]
	date_round.text = "ROUND %s/%s" % [round_index, round_total]
	date_separator.visible = true
	date_round.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property($DateMargin,"scale", Vector2(1.25, 1.25), 0.2)
	tween.tween_property($DateMargin,"scale", Vector2(1.0, 1.0), 0.1)
	

func hide_round():
	date_separator.visible = false
	date_round.visible = false

#display score values, send negative value as parameter to avoid modification
func display_score(total:int, bounce:int, dist:int):
	if total >= 0 :
		score_total_label.text = "%d" % [total]
	if bounce >= 0 :
		score_bounce_label.text = "%d" % [bounce]
	if dist >= 0 :
		score_dist_label.text = "%d" % [dist]
	
	if score_bounce_previous != bounce:
		var tween = get_tree().create_tween()
		tween.tween_property($ScoreLabel/cont_splash/MarginContainer2/Container_Bounce/Label_Bounce,"scale", Vector2(1, 1.25), 0.05)
		tween.tween_property($ScoreLabel/cont_splash/MarginContainer2/Container_Bounce/Label_Bounce,"scale", Vector2(1.0, 1.0), 0.05)
	if score_dist_previous != dist:
		var tween = get_tree().create_tween()
		tween.tween_property($ScoreLabel/cont_speed/Container_Dist/Label_Dist,"scale", Vector2(1, 1.25), 0.05)
		tween.tween_property($ScoreLabel/cont_speed/Container_Dist/Label_Dist,"scale", Vector2(1.0, 1.0), 0.05)
	score_bounce_previous = bounce
	score_dist_previous = dist
	
	if score_root.visible && score_total != total:
		var tween = get_tree().create_tween()
		tween.tween_property($ScoreLabel/TotalRoot,"scale", Vector2(1.5, 1), 0.05)
		tween.tween_property($ScoreLabel/TotalRoot,"scale", Vector2(1.0, 1.0), 0.05)
		
	score_total = total
		

func set_score_visible(_visible:bool):
	score_root.visible = _visible

func set_total_score_visible(_visible:bool):
	score_total_root.visible = _visible
	if _visible:
		var tween = get_tree().create_tween()
		tween.tween_property($ScoreLabel/TotalRoot,"scale", Vector2(1.5, 1), 0.05)
		tween.tween_property($ScoreLabel/TotalRoot,"scale", Vector2(1.0, 1.0), 0.05)
		
