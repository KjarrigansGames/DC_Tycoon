extends Control

var cash = 1000
var num_nodes = 0
var num_racks = 0
const MAX_NODES = 21
const MAX_RACKS = 5
const INCOME_PER_NODE = 50

func _on_Buy_Node_pressed():	
	if not enough_money_for("node"):
		notice("You don't have enough money to buy a node")
		return

	var racks = get_parent().find_node("Datacenter").get_children()
	if (num_racks * MAX_NODES) - num_nodes < 1:
		notice("No empty rack slot left!")
		return
	
	var rack = racks[num_nodes / MAX_NODES]
	var node = load("res://Node_A.tscn").instance()
	node.position = Vector2(0, num_nodes % MAX_NODES * 18)
	rack.add_child(node)
	num_nodes += 1
	cash -= cost_for("node")
	update_stats_panel()

func _on_Buy_Rack_pressed():
	if not enough_money_for("rack"):
		notice("You don't have enough money to buy a rack")
		return

	if num_racks >= MAX_RACKS:
		notice("Datacenter full")
		return
		
	var rack = load("res://Rack_A.tscn").instance()
	rack.set_h_size_flags(SIZE_EXPAND_FILL)
	get_parent().find_node("Datacenter").add_child(rack)
	num_racks += 1
	cash -= cost_for("rack")
	update_stats_panel()

func cost_for(obj_type):
	var cost = -1
	match obj_type:
		"rack": cost = 200
		"node": cost = 800
	return cost
	
func enough_money_for(obj_type):
	var cost = cost_for(obj_type)
	return cost >= 0 && (cash - cost) >= 0

func update_stats_panel():
	get_node("VBox/Layout/RackSlots/Text").text = "Racks %s / %s" % [num_racks, MAX_RACKS]
	get_node("VBox/Layout/NodeSlots/Text").text = "Nodes %s / %s" % [num_nodes, num_racks * MAX_NODES]
	get_node("VBox/Layout/Cash/Text").text = "$ %s" % cash

var notice_timer = Timer.new()
var game_ticks = Timer.new()
func _ready():
	notice_timer.one_shot = true
	notice_timer.wait_time = 10.0
	add_child(notice_timer)
	notice_timer.connect("timeout", self, "_remove_notice")
	notice_timer.start()
	
	add_child(game_ticks)
	game_ticks.wait_time = 1.0
	game_ticks.connect("timeout", self, "_tick")
	game_ticks.start()

func _tick():
	cash += (num_nodes * INCOME_PER_NODE)
	if cash > 50000:
		notice("You have won!")
		game_ticks.stop()
	update_stats_panel()
	
func _remove_notice():
    get_node("VBox/Message").text = ""

func notice(text, timeout = 2.0):
	prints(text)
	get_node("VBox/Message").text = text
	notice_timer.wait_time = timeout
	notice_timer.start()