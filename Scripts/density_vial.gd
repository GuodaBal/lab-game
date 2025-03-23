extends StaticBody2D

@onready var liquid1 := $Liquid1 as Sprite2D
@onready var liquid2 := $Liquid2 as Sprite2D
@onready var liquid3 := $Liquid3 as Sprite2D
@onready var liquid4 := $Liquid4 as Sprite2D

@onready var liquids = [liquid1, liquid2, liquid3, liquid4]
var sequence = []

func _on_area_2d_area_entered(area: Area2D) -> void:
	if !area.get_parent().empty:
		area.get_parent().empty_container()
		for liquid in liquids:
			if !liquid.visible:
				liquid.visible = true
				liquid.modulate = area.get_parent().color
				liquid.material.set_shader_parameter("edge_width", 0.004)
				sequence.append(area.get_parent().density)
				break
		if sequence.size() > 1:
			liquids[sequence.size() - 2].material.set_shader_parameter("edge_width", 0.0)
			for i in range(1, sequence.size()):
				if sequence[i] > sequence[i-1]:
					var color = mix_colors(liquids[i], liquids[i-1])
					liquids[i].modulate = color
					liquids[i-1].modulate = color
					await get_tree().create_timer(1.0).timeout
					get_parent().level_complete(false)
					return
		if sequence.size() == 4:
			get_parent().level_complete(true)

func mix_colors(first_liquid, second_liquid):
	var color1 = first_liquid.modulate as Color
	var color2 = second_liquid.modulate as Color
	var mixed_color = Color((color1.r + color2.r) / 2,(color1.g + color2.g) / 2,(color1.b + color2.b) / 2)
	return mixed_color
