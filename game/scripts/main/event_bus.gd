extends Node

signal new_launch(direction: Vector3, force: float)
signal bounce(is_lucky:bool)
signal launch_done(distance: float, bounces: int)
signal scoring_show(distance: float, bounces: int)
signal scoring_done(round_score: float)
signal shop_requested()
signal shop_ended()
signal show_tournament(day_index: int, round_index: int, current_score: int)
signal hide_tournament(round_rank: int)
