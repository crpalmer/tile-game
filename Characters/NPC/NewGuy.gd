extends NPC

var last_was_name = false

func _ready():
	set_speaker_name("New Guy")
	set_conversation_starter("Hello.  You found me!")

func player_said(text):
	var words = tokenize(text)
	var was_name = false
	if (last_was_name and words.size() == 1 and words[0] == "why") or ("new" in words and "guy" in words):
		say("Yeah, it's a strange name.  My mother wasn't very creative...")
	elif "name" in words:
		say("I'm called " + speaker_name)
		was_name = true
	elif "who" in words and "are" in words and "you" in words:
		say("Some guy sitting in the dungeon.")
	else:
		player_said_default(words)
	last_was_name = was_name
