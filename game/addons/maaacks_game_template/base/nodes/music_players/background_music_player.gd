extends AudioStreamPlayer

func _ready() -> void:
	EventBus.shop_requested.connect(play_shop)
	EventBus.shop_ended.connect(play_main)
	EventBus.launch_done.connect(play_silence)
	EventBus.hide_tournament.connect(play_main)

func play_silence(_a, _b):
	fade_to_track("Silence")

func play_shop(_a):
	fade_to_track("Shop")

func play_main():
	fade_to_track("Main")

func fade_to_track(clip_name: String):
	# Retrieve the playback object from the player
	var playback = get_stream_playback() as AudioStreamPlaybackInteractive

	if playback:
		# This automatically looks up the transition rule you made in the Inspector
		playback.switch_to_clip_by_name(clip_name)
