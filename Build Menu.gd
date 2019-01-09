extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

var num_nodes = 0;
var num_racks = 0
const MAX_NODES = 21;
const MAX_RACKS = 5

func _on_Buy_Node_pressed():
	
	var racks = get_parent().find_node("Datacenter").get_children()
	if (num_racks * MAX_NODES) - num_nodes < 1:
		prints("No empty rack slot left!")
		return

	var rack = racks[num_nodes / MAX_NODES]
	var node = load("res://Node_A.tscn").instance()
	node.position = Vector2(0, num_nodes % MAX_NODES * 18)
	rack.add_child(node)
	num_nodes += 1

func _on_Buy_Rack_pressed():
	if num_racks >= MAX_RACKS:
		prints("Datacenter full")
		return
	num_racks += 1
	var rack = load("res://Rack_A.tscn").instance()
	rack.set_h_size_flags(SIZE_EXPAND_FILL)
	get_parent().find_node("Datacenter").add_child(rack)
