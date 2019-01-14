extends MarginContainer

var nodes = Array()
var max_nodes = 21

func _ready():
	set_h_size_flags(SIZE_EXPAND_FILL)

func add_node(node):
	node.position = Vector2(0, nodes.size() % max_nodes * 18)
	nodes.append(node)
	add_child(node)
	
func cost():
	return 200
	
func height():
	return max_nodes * 18.0 + 23
	
func width():
	return 199