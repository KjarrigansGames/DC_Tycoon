extends Control

var notice_timer = Timer.new()
func _ready():
	notice_timer.one_shot = true
	notice_timer.wait_time = 10.0
	add_child(notice_timer)
	notice_timer.connect("timeout", self, "_remove_notice")
	notice_timer.start()	

func _on_Buy_Node_pressed():	
	var node = load("res://Node.tscn").instance()
	
	if not get_parent().enough_space_for(node):
		return		
	
	if get_parent().pay_for(node):
		get_parent().add_node(node)

func _on_Buy_Rack_pressed():
	var rack = load("res://Rack.tscn").instance()
	
	if not get_parent().enough_space_for(rack):
		return	
	
	if get_parent().pay_for(rack):
		get_parent().add_rack(rack)

func update_stats_panel():
	pass
	get_node("VBox/Layout/RackSlots/Text").text = "Racks %s / %s" % [get_parent().racks.size(), get_parent().MAX_RACKS]
	get_node("VBox/Layout/NodeSlots/Text").text = "Nodes %s / %s" % [get_parent().num_nodes(), get_parent().max_nodes()]
	get_node("VBox/Layout/Cash/Text").text = "$ %s" % get_parent().cash
	
func _remove_notice():
    get_node("VBox/Message").text = ""

func notice(text, timeout = 2.0):
	prints(text)
	get_node("VBox/Message").text = text
	notice_timer.wait_time = timeout
	notice_timer.start()