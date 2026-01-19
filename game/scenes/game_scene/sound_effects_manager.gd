extends Node2D
class_name SoundEffectsManager

@export var bounce_sfx: AudioStream
@export var lucky_bounce_sfx: AudioStream
@export var last_bounce_sfx: AudioStream
@export var click_sfx: Array[AudioStream]
@onready var audio_player: AudioStreamPlayer = $"AudioStreamPlayer"
var audio_stream_playback: AudioStreamPlaybackPolyphonic


func _ready() -> void:
	audio_player.play()
	EventBus.bounce.connect(play_bounce)
	EventBus.launch_done.connect(play_last_bounce)
	audio_stream_playback = audio_player.get_stream_playback()


func play_last_bounce(_a, _b):
	play_sound_instance(last_bounce_sfx)


func play_bounce(is_lucky):
	play_sound_instance(lucky_bounce_sfx if is_lucky else bounce_sfx)


func play_sound_instance(sound_file: AudioStream):
	audio_stream_playback.play_stream(sound_file)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		play_sound_instance(click_sfx.pick_random())
