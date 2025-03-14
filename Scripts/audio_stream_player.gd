extends AudioStreamPlayer

@onready var Music_Bus_ID = AudioServer.get_bus_index("Music")
@onready var SFX_Bus_ID = AudioServer.get_bus_index("SFX")
@onready var Master_Bus_ID = AudioServer.get_bus_index("Master")

var mute_pressed: bool = false


var saved_music_volume = 10.0
var saved_SFX_volume = 1.0

var audio_player = null

func get_MusicID():
	return Music_Bus_ID

func get_SFXID():
	return SFX_Bus_ID

func get_MasterID():
	return Master_Bus_ID

func get_mute_state():
	return mute_pressed
	
func set_mute_state(value: bool):
	mute_pressed = value
	
func set_music_volume(value: float) -> void:
	saved_music_volume = value

func get_music_volume() -> float:
	return saved_music_volume
	

func set_SFX_volume(value: float) -> void:
	saved_SFX_volume = value

func get_SFX_volume() -> float:
	return saved_SFX_volume
	
func play_bg_music():
	if not audio_player:  # Sukuriame tik jei dar nėra
		audio_player = AudioStreamPlayer.new()
		audio_player.stream = preload("res://Assets/zaidimo_backtrackas_fixed.mp3")
		audio_player.process_mode = Node.PROCESS_MODE_ALWAYS  # Nustatome, kad procesas vyktų visada	
		audio_player.bus = "Music"	
		add_child(audio_player)
	if not audio_player.playing:  # Patikriname, ar garsas jau negroja
		audio_player.play()
	#volume_db = saved_music_volume
	#if stream == bg_music:
		#return
	#stream = bg_music
	#play()
