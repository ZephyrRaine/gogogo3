extends Node

signal new_launch(direction: Vector3, force: float)
signal launch_done(distance: float, bounces: int)
signal scoring_show(distance: float, bounces: int, target_score:int)
signal scoring_done()
signal shop_requested()
signal shop_ended()
