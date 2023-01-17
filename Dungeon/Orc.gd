extends Actor

func _ready():
	hp = roll_die(8)
	ac = 4
	to_hit_ac10 = 10
	damage_dice = {"n": 1, "d": 8, "plus": 1}
	speed = 96
	mood = Mood.NEUTRAL
