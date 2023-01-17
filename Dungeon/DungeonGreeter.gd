extends Actor

var state:Dictionary

func _ready():
	state = GameState.get(name)
	$Conversation.speaker_name = "Bob"
	conversation_starter()

func conversation_starter():
	var player_name = state.get("player_name")
	if player_name: $Conversation.starter = "Hi " + player_name
	else: $Conversation.starter = "Hi my name is Bob.  Who are you?"

func player_said(said):
	if not state.has("player_name"):
		state["player_name"] = said
		conversation_starter()
		$Conversation.say("Hi " + state["player_name"] + ".  Did you know that I've been trapped in this dungeon for years and years?  There's been so many things come in here but no one ever leaves.\n\nWhat can I do for you?")
	else:
		player_asked(said)

func player_asked(said:String):
	var words:Array = $Conversation.tokenize(said)
	if "quest" in words or "quests" in words:
		$Conversation.say_in_parts(["I don't know about any quests.  Ask at the temple.", "They are always sending people off to strange places"])
	elif "bribe" in words:
		$Conversation.end_conversation("I'm offended")
	elif "strange" in words and "places" in words:
		$Conversation.say("I hear that the temple even sent one person to Canada!!!")
	else:
		$Conversation.player_said_default(words)
