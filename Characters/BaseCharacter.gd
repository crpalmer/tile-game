extends KinematicBody2D
class_name BaseCharacter

export var speed = 128
export var ac = 10
export var hp = 1
export var max_hp = 1
export var secs_between_attacks = 1.0
export var to_hit_ac10 = 12
export var damage_dice = { "n": 1, "d": 6, "plus":0 }
export var hostile = false
var attack_available = true
var timer:Timer

func _ready():
	randomize()
	timer = Timer.new()
	timer.connect("timeout", self, "attack_timer_expired")
	add_child(timer)

func attack(who:BaseCharacter):
	if not who: return
	
	who.hostile = true
	attack_available = false
	timer.start(secs_between_attacks)

	var roll = roll_die(20)
	var need = to_hit_ac10 + (10 - who.ac)
	if roll == 20 or roll >= to_hit_ac10 + (10-who.ac):
		var damage = roll_dice(damage_dice)
		who.hp -= damage
		print_debug(name + " damage to " + who.name + ": " + String(damage) + " roll " + String(roll))
		if who.hp <= 0: who.died()
	else:
		print_debug(name + " miss " + who.name + ": "+ String(roll) + " needed " + String(need))

func roll(n:int, d:int, plus:int = 0):
	var total = plus
	for i in n:
		total += randi()%d+1
	return total

func roll_die(d:int):
	return roll(1, d, 0)

func roll_dice(d:Dictionary):
	return roll(d.n, d.d, d.plus)

func attack_timer_expired():
	attack_available = true

func died():
	print_debug("killed!")
	queue_free()
