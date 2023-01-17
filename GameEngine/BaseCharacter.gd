extends Thing
class_name BaseCharacter

enum Mood { FRIENDLY, NEUTRAL, HOSTILE }
export var speed = 128
export var ac = 10
export var hp = 1
export var max_hp = 1
export var secs_between_attacks = 1.0
export var to_hit_ac10 = 12
export var damage_dice = { "n": 1, "d": 6, "plus":0 }
var mood = Mood.NEUTRAL
var damage_popup_packed = preload("res://GameEngine/DamagePopup.tscn")
var attack_available = true
var timer:Timer

func _ready():
	randomize()
	timer = Timer.new()
	timer.connect("timeout", self, "attack_timer_expired")
	add_child(timer)

func attack(who:BaseCharacter):
	if not who: return
	if not attack_available: return
	
	who.mood = Mood.HOSTILE
	attack_available = false
	timer.start(secs_between_attacks)

	var roll = roll_die(20)
	var need = to_hit_ac10 + (10 - who.ac)
	if roll == 20 or roll >= to_hit_ac10 + (10-who.ac):
		var damage = roll_dice(damage_dice)
		print_debug(name + " damage to " + who.name + ": " + String(damage) + " roll " + String(roll))
		process_attack_outcome(who, true, damage)
	else:
		print_debug(name + " miss " + who.name + ": "+ String(roll) + " needed " + String(need))
		process_attack_outcome(who, false)
		
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

func default_process(delta, with_player = false):
	if GameState.paused: return
	
	
	if mood == Mood.HOSTILE:
		if with_player: attack(GameState.player)
		else:
			var dir:Vector2 = GameState.player.position - position
			dir /= dir.length()
			var collision = move_and_collide(dir * delta * speed)
			if collision and collision.collider != GameState.player:
				move_and_collide(collision.remainder.length() * collision.normal)
	elif with_player and mood == Mood.NEUTRAL:
		mood = Mood.HOSTILE

func _process(delta):
	default_process(delta)
	
func process_attack_outcome(who, hit, damage = 0):
	var damage_popup = damage_popup_packed.instance()
	damage_popup.find_node("Damage").text = String(damage)
	damage_popup.find_node("Damage").visible = hit
	damage_popup.find_node("Hit").visible = hit
	damage_popup.find_node("Miss").visible = not hit
	damage_popup.visible = true
	who.hp -= damage
	who.add_child(damage_popup)
	var sleep = 0.65 if who.hp > 0 else 0.35
	yield(get_tree().create_timer(sleep), "timeout")
	if who.hp <= 0: who.died()
	else: damage_popup.queue_free()
