extends Area2D
class_name TrackingArea

var in_area:Dictionary

func who_is_in_area():
	for who in in_area.keys():
		if in_area[who]: return who
	return null

func _on_TrackingArea_body_entered(body):
	record_area(body, true)

func _on_TrackingArea_body_exited(body):
	record_area(body, true)

func _on_TrackingArea_area_entered(area):
	record_area(area, true)

func _on_TrackingArea_area_exited(area):
	record_area(area, false)

func record_area(who, what):
	var parent = who.get_parent()
	if who == self or who == get_parent() or who is TileMap: return
	if who and who is PhysicsBody2D: record_area(parent, what)
	else: in_area[who] = what
