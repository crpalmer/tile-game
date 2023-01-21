extends Thing
class_name InventoryThing

export var n = 1
export var plural:String
export var singular:String

func to_string():
	if n > 1: return String(n) + " " + plural
	else: return singular
