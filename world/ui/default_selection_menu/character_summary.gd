extends Label

var character = Data.persistence.char_data.duplicate(true)

func _ready():
	update()
		
		
func update():
	text = ""
	character = Data.persistence.char_data.duplicate(true)
	for i in character:
		if i == "defaults":
			for j in character[i]:
				text = text + j.capitalize() + " : " + str(character[i][j]) + "\n"
		else:
			text = text + i.capitalize() + " : " + str(character[i]) + "\n"
