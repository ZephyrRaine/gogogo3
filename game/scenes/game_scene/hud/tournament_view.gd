extends Control
class_name TournamentView

@export var day_label: Label
@export var rows_container: BoxContainer
@export var row_prefab: PackedScene

var gains = [5, 4, 3, 2, 1, 1, 1, -1]

func get_rank(scores: Array, player_score: int) -> int:
	for i in range(scores.size()):
		if player_score >= scores[i]:
			return i

	return scores.size()


func display_tournament(goals:Array, player_score, day:int, round_index:int):
	visible = true
	day_label.text = "Day %d " % [day+1]
	if round_index >= 0:
		day_label.text += "- Round %d/3" % [round_index+1]

	for n in rows_container.get_children():
		n.queue_free()

	var i = 0
	var rank_index = get_rank(goals, player_score)
	goals.insert(rank_index, player_score)

	for g in goals:
		var instance = row_prefab.instantiate()

		instance.set_row(i + 1, goals[i], gains[i], i == rank_index)
		rows_container.add_child(instance)
		i += 1

	return rank_index
