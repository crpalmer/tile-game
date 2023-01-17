extends Area2D
class_name TrackingArea

signal entered
signal exited

var in_area:Dictionary
var player_is_in_area = false

func _ready():
	connect("area_entered", self, "area_entered")
	connect("body_entered", self, "area_entered")

	connect("area_exited", self, "area_exited")
	connect("body_exited", self, "area_exited")

func set_tracking_radius(radius:int):
	$Circle.shape.set_radius(radius)
	
func who_is_in_area():
	var res = []
	for who in in_area.keys():
		if in_area[who] > 0: res.push_back(who)
	return res

func area_entered(who):
	record_area(who, +1)

func area_exited(who):
	record_area(who, -1)

func is_filtered_area(who):
	var parent = who.get_parent()
	if not parent or not parent is Actor: return false
	return who.name == "VisionArea" or who.name == "CloseArea"
	
func record_area(who, what):
	if is_filtered_area(who): return
	
	var parent = who.get_parent()
	
	if who == self or who == get_parent() or who is TileMap: return
	if parent and parent is PhysicsBody2D: record_area(parent, what)
	if in_area.has(who): in_area[who] += what
	else: in_area[who] = what
	if in_area[who] < 0: in_area[who] = 0
	
	if who == GameState.player: player_is_in_area = what
	
	if what > 0:
		emit_signal("entered", who)
	else:
		emit_signal("exited", who)
	print_debug(who.name + " is in area " + name + " of " + get_parent().name + " " + String(in_area[who]) + " times")
