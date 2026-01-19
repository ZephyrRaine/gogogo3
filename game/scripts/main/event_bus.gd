extends Node

#after shop, before launch, the in-between
signal new_round(day_index:int, round_index:int)
signal new_launch(direction: Vector3, force: float)
signal start_launch(pebble: Pebble)

signal bounce(is_lucky:bool)
signal launch_done(distance: float, bounces: int)
signal scoring_show(distance: float, bounces: int)
signal scoring_done(round_score: float)
signal shop_requested(money : int)
signal shop_ended()
signal show_tournament(tournament_dict:Dictionary)
signal hide_tournament()

signal spend_money(previous_money:int, new_money:int)
