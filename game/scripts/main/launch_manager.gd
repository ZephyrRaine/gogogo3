class_name LaunchManager
extends Node2D

enum LaunchPhases { NONE, LAUNCH_AIM, LAUNCH_FORCE }

@export var current_launching_phase: LaunchPhases = LaunchPhases.NONE
@export var aim_indicator: AimIndicator

@export var aim_ratio_speed: float
@export var aim_ratio_target: float

var aim_ratio_direction: int = 1
var aim_ratio: float = 0.0

@export var bypass_forceTest = true
@export var force_indicator: ForceIndicator
@export var force_ratio_speed: float
var force_ratio_direction: int = 1
var force_ratio: float = 0.0


func _ready() -> void:
	aim_indicator.set_target_rotation(aim_ratio_target)
	aim_ratio_direction = 1 if randf() < 0.5 else -1
	aim_ratio = randf()
	aim_indicator.set_needle_rotation(aim_ratio)
	force_indicator.visible = false


func _input(event: InputEvent) -> void:
	if !visible || current_launching_phase == LaunchPhases.NONE:
		return
	if event.is_action_pressed("interact"):
		match current_launching_phase:
			LaunchPhases.LAUNCH_AIM:
				aim_indicator.visible = false
				force_indicator.visible = true
				
				if (bypass_forceTest): 
					force_ratio = 1
					launch()
				else: current_launching_phase = LaunchPhases.LAUNCH_FORCE
			LaunchPhases.LAUNCH_FORCE:
				launch()

func _process(delta: float) -> void:
	match current_launching_phase:
		LaunchPhases.LAUNCH_AIM:
			aim_ratio += delta * aim_ratio_speed * aim_ratio_direction
			aim_ratio = clamp(aim_ratio, 0.0, 1.0)
			if aim_ratio <= 0.0 || aim_ratio >= 1.0:
				aim_ratio_direction *= -1
			aim_indicator.set_needle_rotation(aim_ratio)
		LaunchPhases.LAUNCH_FORCE:
			force_ratio += delta * force_ratio_speed * force_ratio_direction
			force_ratio = clamp(force_ratio, 0.0, 1.0)
			if force_ratio <= 0.0 || force_ratio >= 1.0:
				force_ratio_direction *= -1
			force_indicator.set_target_speed(force_ratio)


func request_launch():
	visible = true
	await get_tree().create_timer(.25).timeout
	current_launching_phase = LaunchPhases.LAUNCH_AIM
	
func launch():
	EventBus.new_launch.emit(aim_ratio_target - aim_ratio, force_ratio)
	current_launching_phase = LaunchPhases.NONE
	force_indicator.visible = false
	aim_indicator.visible = true
	visible = false
	
