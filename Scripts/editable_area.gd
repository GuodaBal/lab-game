@tool
extends Area2D

func _ready() -> void:
	if Engine.is_editor_hint() and get_scene_file_path() != "":
		self.get_parent().set_editable_instance(self,true)
