extends KinematicBody2D
class_name Actor

enum Mood { FRIENDLY = 0, NEUTRAL = 1, HOSTILE =2 }

export var display_name:String = name
export var ac = 10
export var hp = 1
export var max_hp = 1
export var to_hit_ac10 = 12
export var damage_dice = { "n": 1, "d": 6, "plus":0 }
export var speed = 128
export var secs_between_attacks = 1.0
export var close_radius = 40
export var vision_radius = 250

export var mood = Mood.FRIENDLY
var attack_available = true

var conversation

func _ready():
	randomize()
	conversation = $Conversation
	set_vision_range(vision_radius)
	set_close_range(close_radius)

func set_vision_range(radius:int):
	$VisionArea.set_tracking_radius(radius)
	vision_radius = radius
	
func set_close_range(radius:int):
	$CloseArea.set_tracking_radius(radius)
	close_radius = radius
	
func attack(who:Actor):
	if not who: return
	if not attack_available: return
	
	who.mood = Mood.HOSTILE
	attack_available = false
	$AttackAvailable.start(secs_between_attacks)

	var roll = roll_die(20)
	if roll == 20 or roll >= to_hit_ac10 + (10-who.ac):
		var damage = roll_dice(damage_dice)
		who.hp -= damage
		GameState.player.show_message(who.name + " takes " + String(damage) + " damage.")
		if who.hp <= 0: who.died()
		else: who.damage_popup(true, damage)
	else:
		who.damage_popup(false)
		
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

func player_is_visible():
	return $VisionArea.player_is_in_area

func process(delta):
	if GameState.paused: return

	if conversation: conversation.process(self, $CloseArea.player_is_in_area)
	
	if mood == Mood.HOSTILE:
		if $CloseArea.player_is_in_area: attack(GameState.player)
		else:
			var dir:Vector2 = GameState.player.position - position
			dir /= dir.length()
			var collision = move_and_collide(dir * delta * speed)
			if collision and collision.collider != GameState.player:
				move_and_collide(collision.remainder.length() * collision.normal)
	elif mood == Mood.NEUTRAL and player_is_visible():
		mood = Mood.HOSTILE
	
func _process(delta):
	process(delta)

func damage_popup(hit, damage = 0):
	$DamagePopup/Damage.text = String(damage)
	$DamagePopup/Damage.visible = hit
	$DamagePopup/Hit.visible = hit
	$DamagePopup/Miss.visible = not hit
	$DamagePopup.visible = true
	$DamagePopupTimer.start(0.5)
	pass
	
func _on_DamagePopupTimer_timeout():
	$DamagePopup.visible = false

func _on_AttackAvailable_timeout():
	attack_available = true
