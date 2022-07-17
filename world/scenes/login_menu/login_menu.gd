extends Control

onready var history = $VSplitContainer/TextEdit
onready var entry = $VSplitContainer/LineEdit
var username
var password

func _ready():
	entry.connect("text_entered", self, "on_text_entered")
	
	
func on_text_entered(text):
	var histext = history.text.split("\n")
	histext = histext[histext.size() -1]
	entry.text = ""
	parse_entry(histext, text)
	
func parse_entry(h, t):
	if "login" in h:
		username = t
		t += "\n" + t + "@delonda's password : "
		entry.secret = true
	elif "password" in h:
		entry.secret = false
		password = t
		Gateway.join(username, t)
		t = "\n"
	elif "account" in h:
		if "y" in t.to_lower():
			Gateway.join(username, password, true)
		elif "n" in t.to_lower():
			bad_password()
		t = "\n"
		#t = "\nPermission denied, please try again.\nlogin :"
	history.text += t

func create_account():
	history.text += "\n"+"Username was not found. Would you like to create this account? [Y/N]"
	pass
	
func bad_password():
	history.text += "\n"+"Permission denied, please try again."
	pass
