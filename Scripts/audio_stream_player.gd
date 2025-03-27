extends AudioStreamPlayer

@onready var Music_Bus_ID = AudioServer.get_bus_index("Music")
@onready var SFX_Bus_ID = AudioServer.get_bus_index("SFX")
@onready var Master_Bus_ID = AudioServer.get_bus_index("Master")

var mute_pressed: bool = false


var saved_music_volume = 8.0
var saved_SFX_volume = 1.0

var audio_player = null
var click_player = null
var level1_player = null
var level2_player = null
var place_player = null

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
	audio_player.volume_db = value

func get_music_volume() -> float:
	return saved_music_volume
	

func set_SFX_volume(value: float) -> void:
	saved_SFX_volume = value
	if click_player:
		click_player.volume_db = saved_SFX_volume 
	if level1_player:
		level1_player.volume_db = saved_SFX_volume
	if level2_player:
		level2_player.volume_db = saved_SFX_volume
	if place_player:
		place_player.volume_db = saved_SFX_volume

func get_SFX_volume() -> float:
	return saved_SFX_volume
	
func play_bg_music():
	if not audio_player:  # Sukuriame tik jei dar nėra
		audio_player = AudioStreamPlayer.new()
		audio_player.stream = preload("res://Assets/zaidimo_backtrackas_fixed.mp3")
		audio_player.process_mode = Node.PROCESS_MODE_ALWAYS  # Nustatome, kad procesas vyktų visada	
		audio_player.bus = "Music"
		audio_player.volume_db = saved_music_volume
		add_child(audio_player)
	if not audio_player.playing:  # Patikriname, ar garsas jau negroja
		audio_player.play()
func play_click_sound():
	if not click_player:  # Sukuriame tik jei dar nėra
		click_player = AudioStreamPlayer.new()
		click_player.stream = preload("res://Assets/Audio/click_sound.mp3")
		click_player.process_mode = Node.PROCESS_MODE_ALWAYS  # Nustatome, kad procesas vyktų visada	
		click_player.bus = "SFX"
		click_player.volume_db = saved_SFX_volume
		add_child(click_player)
	click_player.play()
	
func play_level1_sound():
	if not level1_player:  # Sukuriame tik jei dar nėra
		level1_player = AudioStreamPlayer.new()
		level1_player.stream = preload("res://Assets/Audio/level_passed.mp3")
		level1_player.process_mode = Node.PROCESS_MODE_ALWAYS  # Nustatome, kad procesas vyktų visada	
		level1_player.bus = "SFX"
		level1_player.volume_db = saved_SFX_volume
		add_child(level1_player)
	level1_player.play()
	
func play_level2_sound():
	if not level2_player:  # Sukuriame tik jei dar nėra
		level2_player = AudioStreamPlayer.new()
		level2_player.stream = preload("res://Assets/Audio/level_failed.mp3")
		level2_player.process_mode = Node.PROCESS_MODE_ALWAYS  # Nustatome, kad procesas vyktų visada	
		level2_player.bus = "SFX"
		level2_player.volume_db = saved_SFX_volume
		add_child(level2_player)
	level2_player.play()
	
func play_place_sound():
	if not place_player:  # Sukuriame tik jei dar nėra
		place_player = AudioStreamPlayer.new()
		place_player.stream = preload("res://Assets/Audio/place.mp3")
		place_player.process_mode = Node.PROCESS_MODE_ALWAYS  # Nustatome, kad procesas vyktų visada	
		place_player.bus = "SFX"
		place_player.volume_db = saved_SFX_volume
		add_child(place_player)
	place_player.play()
