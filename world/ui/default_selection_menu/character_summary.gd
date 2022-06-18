extends Label

var character = Data.persistence.char_data.duplicate(true)

func _ready():
	update()
		
		
func update():
	text = ""
	character = Data.persistence.char_data.duplicate(true)
	for i in character:
		text = text + i.capitalize() + " : " + str(character[i]) + "\n"
