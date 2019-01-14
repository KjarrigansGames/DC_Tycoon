extends Node

const MAX_RACKS = 5
const INCOME_PER_NODE = 50

var racks = Array()
var cash = 10000

var game_ticks = Timer.new()
func _ready():
	add_child(game_ticks)
	game_ticks.wait_time = 1.0
	game_ticks.connect("timeout", self, "_tick")
	game_ticks.start()	

func _tick():
	cash += (num_nodes() * INCOME_PER_NODE)
	if cash > 50000:
		$HUD.notice("You have won!")
		game_ticks.stop()
	$HUD.update_stats_panel()

func pay_for(obj):
	if enough_money_for(obj):
		cash -= obj.cost()
		$HUD.update_stats_panel()
		return true
	return false

func enough_money_for(obj):
	var enough = (cash - obj.cost()) > 0
	if enough:
		return true 
		
	$HUD.notice("You don't have enough money to buy a %s" % obj.get_name())	
	return false

func enough_space_for(obj):
	var enough = false
	match obj.get_name():
		"Rack": enough = racks.size() < MAX_RACKS
		"Node": enough = free_rack()
	if not enough:
		$HUD.notice("Not enough space for another %s" % obj.get_name())
	return enough

func add_rack(rack):
	rack.anchor_left = 0.0
	rack.anchor_bottom = 0.0
	rack.anchor_right = 0.0
	rack.anchor_top = 0.0
	rack.margin_top = $Datacenter.rect_size.y - rack.height() - 10
	rack.margin_left = (racks.size() * (rack.width() + 2)) + 10
	rack.margin_right = rack.width()
	racks.append(rack)
	$Datacenter.add_child(rack)
	
func add_node(node):
	free_rack().add_node(node)

func free_rack():
	for rack in racks:
		if rack.nodes.size() < rack.max_nodes:
			return rack
	return false

func cost_for(obj_type):
	var cost = -1
	match obj_type:
		"rack": cost = 200
		"node": cost = 800
	return cost
	
func num_nodes():
	var sum = 0
	for rack in racks:
		sum += rack.nodes.size()
	return sum
	
func max_nodes():
	var sum = 0
	for rack in racks:
		sum += rack.max_nodes	
	return sum	
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()