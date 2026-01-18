extends Control
class_name TournamentView

@export var day_label: Label
@export var rows_container: BoxContainer
@export var row_prefab: PackedScene

func display_tournament(tournament: Dictionary):
	visible = true
	day_label.text = "Day %d " % [tournament.day_index + 1]
	if tournament.round_index >= 0:
		day_label.text += "- Round %d/3" % [tournament.round_index + 1]

	for n in rows_container.get_children():
		n.queue_free()

	var i = 0
	var goals = tournament.goals.duplicate()
	goals.insert(tournament.rank_index, tournament.player_score)

	for g in goals:
		var instance = row_prefab.instantiate()
		instance.set_row(
			i + 1, goals[i], tournament.gains[i], i == tournament.rank_index
		)
		rows_container.add_child(instance)
		i += 1
