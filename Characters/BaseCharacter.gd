extends Node2D
class_name BaseCharacter

var ac = 10
var hp = 1
var max_hp = 1
var to_hit_ac10 = 12
var damage_dice = { "n": 2, "d": 6, "plus":1 }
var hostile = false

func _ready():
	randomize()
	
func attack(who:BaseCharacter, node:Node2D):
	if not who: return
	who.hostile = true
	var roll = roll_die(20)
	var need = to_hit_ac10 + (10 - who.ac)
	if roll == 20 or roll >= to_hit_ac10 + (10-who.ac):
		var damage = roll_dice(damage_dice)
		who.hp -= damage
		print_debug("damage " + String(damage) + " roll " + String(roll))
		if who.hp < 0:
			print_debug("killed!")
			node.queue_free()
#			who.visible = false
	else:
		print_debug("miss " + String(roll) + " needed " + String(need))

func roll(n:int, d:int, plus:int = 0):
	var total = plus
	for i in n:
		total += randi()%d+1
	return total

func roll_die(d:int):
	return roll(1, d, 0)

func roll_dice(d:Dictionary):
	return roll(d.n, d.d, d.plus)
