extends AudioStreamPlayer

var bg_music = preload("res://Assets/zaidimo_backtrackas_fixed.mp3")

func play_bg_music(volume = 10.0):
	if stream == bg_music:
		return
	stream = bg_music
	volume_db = volume
	play()
