class_name LaunchManager
extends Node2D

enum LaunchPhases { NONE, LAUNCH_AIM, LAUNCH_FORCE }

@export var current_launching_phase: LaunchPhases = LaunchPhases.NONE
@export var aim_indicator: AimIndicator

@export var aim_ratio_speed: float
@export var aim_ratio_target: float

var aim_ratio_direction: int = 1
var aim_ratio: float = 0.0


func _ready() -> void:
	aim_indicator.set_target_rotation(aim_ratio_target)
	aim_ratio_direction = 1 if randf() < 0.5 else -1
	aim_ratio = randf()
	aim_indicator.set_needle_rotation(aim_ratio)


func _input(event: InputEvent) -> void:
	if !visible || current_launching_phase == LaunchPhases.NONE:
		return
	if event.is_action_pressed("interact"):
		EventBus.new_launch.emit(aim_ratio_target - aim_ratio, 1)
		current_launching_phase = LaunchPhases.NONE
		visible = false


func _process(delta: float) -> void:
	if current_launching_phase == LaunchPhases.LAUNCH_AIM:
		aim_ratio += delta * aim_ratio_speed * aim_ratio_direction
		if aim_ratio <= 0.0 || aim_ratio >= 1.0:
			aim_ratio_direction *= -1
		aim_indicator.set_needle_rotation(aim_ratio)


func request_launch():
	current_launching_phase = LaunchPhases.LAUNCH_AIM
	visible = true
