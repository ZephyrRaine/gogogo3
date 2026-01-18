extends Node2D
class_name SoundEffectsManager

@export var bounce_sfx: AudioStream
@export var lucky_bounce_sfx: AudioStream
@onready var audio_player : AudioStreamPlayer = $"AudioStreamPlayer"
var audio_stream_playback : AudioStreamPlaybackPolyphonic

func _ready() -> void:
	audio_player.play();
	EventBus.bounce.connect(play_bounce)
	audio_stream_playback = audio_player.get_stream_playback()

func play_bounce(is_lucky):
	play_sound_instance(lucky_bounce_sfx if is_lucky else bounce_sfx)

func play_sound_instance(sound_file: AudioStream):
	audio_stream_playback.play_stream(sound_file)
