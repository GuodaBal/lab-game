extends "item_destination.gd"

@export var has_wire = false
@export var wire_connected_to : Array[Node] = []
var has_power = false
var can_be_powered = false

func power_connections():
	##Checking if empty spot for element
	if correct_id == 0 || can_be_powered:
		has_power = true
		#Updating lamps
		get_tree().call_group("lamp", "refresh")
		for connection in wire_connected_to:
			if !connection.has_electricity:
				connection.power_connections()

func depower_connections():
	has_power = false
	#Updating lamps
	get_tree().call_group("lamp", "refresh")
	for connection in wire_connected_to:
		if connection.has_electricity:
			connection.depower_connections()

func powered_from_item():
	can_be_powered = true
	get_tree().call_group("battery", "refresh")

func depowered_from_item():
	can_be_powered = false
	get_tree().call_group("battery", "refresh")
	
