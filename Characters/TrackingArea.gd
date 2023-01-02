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

func who_is_in_area():
	for who in in_area.keys():
		if in_area[who]: return who
	return null

func area_entered(who):
	record_area(who, true)

func area_exited(who):
	record_area(who, false)

func record_area(who, what):
	var parent = who.get_parent()
	if who == self or who == get_parent() or who is TileMap: return
	if parent and parent is PhysicsBody2D: record_area(parent, what)
	elif not in_area.has(who) or in_area[who] != what:
		in_area[who] = what
		if who == GameState.player: player_is_in_area = what
		if what: emit_signal("entered", who)
		else: emit_signal("exited", who)
