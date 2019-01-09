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

func _on_Buy_Node_pressed():
	
	var racks = get_parent().find_node("Datacenter").get_children()
	if racks.size() == 0:
		prints("Leer")
		return
		
	# TODO: look for next empty rack
	var rack = racks[0]
	
	var scene = load("res://Node_A.tscn").instance()
	rack.add_child(scene)
	
var num_racks = 0
const MAX_RACKS = 5

func _on_Buy_Rack_pressed():
	if num_racks >= MAX_RACKS:
		prints("Datacenter full")
		return
	num_racks += 1
	var scene = load("res://Rack_A.tscn").instance()
	scene.set_h_size_flags(SIZE_EXPAND_FILL)
	get_parent().find_node("Datacenter").add_child(scene)
