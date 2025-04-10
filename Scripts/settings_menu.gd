extends Control


@onready var GraphicsMenu := $CanvasLayer/Graphics
@onready var SoundMenu := $CanvasLayer/Sound

@onready var Fullscreen := $CanvasLayer/Graphics/FullscreenButton
@onready var ResolutionSelector := $CanvasLayer/Graphics/ResolutionSelector


var Music_Bus_ID = GlobalAudioStreamPlayer.get_MusicID()
var SFX_Bus_ID = GlobalAudioStreamPlayer.get_SFXID()
var Master_Bus_ID = GlobalAudioStreamPlayer.get_MasterID()
var mute_press = GlobalAudioStreamPlayer.get_mute_state()  # atkurkite išsaugotą būseną
var waiting_for_input: bool = false
var button
var action


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GraphicsMenu.visible = true
	SoundMenu.visible = false
	var group = ButtonGroup.new()
	$CanvasLayer/GraphicsSelect.button_group = group
	$CanvasLayer/SoundSelect.button_group = group
	
	#for index in ResolutionSelector.item_count:
		#if ResolutionSelector.get_item_text(index) == str(Settings.resolution_x)+"x"+str(Settings.resolution_y):
			#ResolutionSelector.select(index)

	#$CanvasLayer/Sound/MusicSlider.value = Settings.music_volume
	#$CanvasLayer/Sound/MiscSlider.value = Settings.misc_volume

func _on_graphics_pressed() -> void:
	GlobalAudioStreamPlayer.play_click_sound()
	GraphicsMenu.visible = true
	SoundMenu.visible = false

func _on_sound_pressed() -> void:
	GlobalAudioStreamPlayer.play_click_sound()
	GraphicsMenu.visible = false
	SoundMenu.visible = true

func _on_back_pressed() -> void:
	#var save_file = FileAccess.open("user://settings.save", FileAccess.WRITE)
	#var save_data = {}
	#save_data["settings"] = Settings.save_data()
	#save_file.store_string(JSON.stringify(save_data))
	if get_parent().get_parent() == null:
		GlobalAudioStreamPlayer.play_click_sound()
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	else:
		GlobalAudioStreamPlayer.play_click_sound()
		queue_free()

func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	GlobalAudioStreamPlayer.play_click_sound()
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		await get_tree().create_timer(0.1).timeout
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	var index = ResolutionSelector.get_selected_id()
	var resolution = ResolutionSelector.get_item_text(index).split("x")
	get_window().size = Vector2i(int(resolution[0]),int(resolution[1]))
	await get_tree().create_timer(1).timeout
	get_window().move_to_center()
	

func _on_resolution_selector_item_selected(index: int) -> void:
	GlobalAudioStreamPlayer.play_click_sound()
	var resolution = ResolutionSelector.get_item_text(index).split("x")
	get_window().size = Vector2i(int(resolution[0]),int(resolution[1]))
	get_window().move_to_center()
	#Settings.resolution_x = resolution[0]
	#Settings.resolution_y = resolution[1]

func _on_music_slider_value_changed(value: float) -> void:
	GlobalAudioStreamPlayer.set_music_volume(linear_to_db(value))
	AudioServer.set_bus_mute(Music_Bus_ID, value < .05)
	#Settings.music_volume = value

func _on_misc_slider_value_changed(value: float) -> void:
	GlobalAudioStreamPlayer.set_SFX_volume(linear_to_db(value))
	#AudioServer.set_bus_volume_db(SFX_Bus_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_Bus_ID, value < .05)
	#Settings.misc_volume = value

func _on_music_slider_ready() -> void:
	$CanvasLayer/Sound/MusicSlider.value = db_to_linear( GlobalAudioStreamPlayer.get_music_volume())
func _on_misc_slider_ready() -> void:
	$CanvasLayer/Sound/MiscSlider.value = db_to_linear( GlobalAudioStreamPlayer.get_SFX_volume())

func _on_mute_button_ready() -> void:
	$CanvasLayer/Sound/MuteButton.button_pressed = mute_press
	AudioServer.set_bus_mute(Master_Bus_ID, mute_press)  # pritaikykite būseną garsui

func _on_mute_button_pressed() -> void:
	GlobalAudioStreamPlayer.play_click_sound()
	var mute_pressed = $CanvasLayer/Sound/MuteButton.button_pressed
	
	GlobalAudioStreamPlayer.set_mute_state(mute_pressed)  # išsaugokite naują būseną
	AudioServer.set_bus_mute(Master_Bus_ID, mute_pressed)  # pritaikykite naują būseną garsui
	#Settings.mute = mute_pressed
