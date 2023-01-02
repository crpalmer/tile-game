extends NPC

var player_name

func _ready():
	set_speaker_name("Bob")
	set_conversation_starter("Hi my name is Bob.  Who are you?")

func player_said(said):
	if not player_name:
		player_name = said
		set_conversation_starter("Hi " + player_name)
		say("Hi " + player_name + ", what can I do for you?")
	else:
		player_asked(said)

func player_asked(said:String):
	var words:Array = tokenize(said)
	if "quest" in words or "quests" in words:
		say_in_parts(["I don't know about any quests.  Ask at the temple.", "They are always sending people off to strange places"])
	elif "bribe" in words:
		end_conversation("I'm offended")
	elif "strange" in words and "places" in words:
		say("I hear that the temple even sent one person to Canada!!!")
	else:
		player_said_default(words)

func _on_Player_collided_with():
	start_conversation()
