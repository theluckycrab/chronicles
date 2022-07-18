extends Control

onready var terminal = $Terminal
var username
var password

func _ready():
	terminal.grab_focus()
	terminal.connect("text_entered", self, "on_text_entered")
	terminal.post("Welcome to the Delonda server. Please provide your credentials."\
	+ " As a reminder, your password will not be censored.\n\n Login : ")
	$Popup/LineEdit.connect("text_entered", self, "take_password")
	$Popup.hide()
	
func on_text_entered(history, line):
	var h = history.split("\n", false)
	h = h[h.size() -1]
	if "Login" in h:
		username = line
		terminal.post(line + "@delonda's password:\n")
		show_pass_prompt()
	if "[Y/N]" in h:
		print("dongers")
		if line.to_lower().begins_with("y"):
			Gateway.join(username, password, true)
		else:
			bad_password()
	
		
#func on_text_entered(text):
#	var histext = history.text.split("\n", false)
#	histext = histext[histext.size() -1]
#	entry.text = ""
#	parse_entry(histext, text)
#
#func parse_entry(h, t):
#	if "login" in h:
#		username = t
#		t += "\n" + t + "@delonda's password : "
#		entry.secret = true
#	elif "password" in h:
#		entry.secret = false
#		password = t
#		Gateway.join(username, t)
#		t = "\n"
#	elif "account" in h:
#		if "y" in t.to_lower():
#			Gateway.join(username, password, true)
#		elif "n" in t.to_lower():
#			bad_password()
#		t = "\n"
#		#t = "\nPermission denied, please try again.\nlogin :"
#	history.text += t
#	on_history_changed()
#
#
func create_account():
	var t = "Username was not found. Would you like to create this account? [Y/N]"
	terminal.post(t)
	pass

func bad_password():
	var t = "Permission denied, please try again.\nLogin :"
	terminal.post(t)
	pass

func take_password(text):
	password = text.sha256_text()
	$Popup.hide()
	terminal.grab_focus()
	terminal.post("Attempting to login as " + username + "..." + "\n")
	Gateway.join(username, password, false)

func show_pass_prompt():
	var h = terminal.text.split("\n", false)
	h = h.size() - 1
	var w = username + "@delonda's password:"
	w = w.length() - 1
	$Popup.rect_global_position = Vector2(w, h) * Vector2(7, 18)
	$Popup.rect_global_position.y += 8
	$Popup.rect_global_position.x += 20
	print(username.length())
	$Popup.show()
	$Popup/LineEdit.grab_focus()
	$Popup/LineEdit.text = ""
