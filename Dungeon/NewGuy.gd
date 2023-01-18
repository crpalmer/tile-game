extends Actor

var last_was_name = false

func _ready():
	$Conversation.starter = "Hello.  You found me!"
	display_name = "New Guy"

func player_said(text):
	var words = $Conversation.tokenize(text)
	var was_name = false
	if (last_was_name and words.size() == 1 and words[0] == "why") or ("new" in words and "guy" in words):
		$Conversation.say("Yeah, it's a strange name.  My mother wasn't very creative...")
	elif "name" in words:
		$Conversation.say("I'm called " + display_name)
		was_name = true
	elif "who" in words and "are" in words and "you" in words:
		$Conversation.say("Some guy sitting in the dungeon.")
	else:
		$Conversation.player_said_default(words)
	last_was_name = was_name
