extends Control

var username: String = ""
var password: String = ""

onready var terminal = $Terminal
onready var pass_prompt = $PasswordPrompt
onready var pass_entry = $PasswordPrompt/PasswordEntry

func _ready():
	var _d = Gateway.connect("login_failed", self, "on_login_failed")
	var _discard = pass_entry.connect("text_entered", self, "take_password")
	var _dis = terminal.connect("text_entered", self, "on_text_entered")
	
	pass_prompt.hide()
	terminal.grab_focus()
	
	terminal.post("Welcome to the Delonda server. Please provide your credentials."\
	+ " As a reminder, your password will not be censored.\n\n Login : ")
	
	
func on_text_entered(history:String, line:String) -> void:
	var h: PoolStringArray = history.split("\n", false)
	var last_prompt = h[h.size() -1]
	
	if "Login" in last_prompt:
		username = line
		terminal.post(line + "@delonda's password:\n")
		show_pass_prompt()
		
	if "[Y/N]" in last_prompt:
		if line.to_lower().begins_with("y"):
			Gateway.join(username, password, true)
		else:
			post_bad_password()
	
func post_create_account() -> void:
	var t: String = "Username was not found. Would you like to create this account? [Y/N]"
	terminal.post(t)

func post_bad_password() -> void:
	var t: String = "Permission denied, please try again.\nLogin :"
	terminal.post(t)

func take_password(text:String) -> void:
	password = text.sha256_text()
	pass_prompt.hide()
	terminal.grab_focus()
	terminal.post("Attempting to login as " + username + "..." + "\n")
	Gateway.join(username, password, false)

func show_pass_prompt() -> void:
	var h = terminal.text.split("\n", false)
	var y_offset = h.size() - 1
	var w = username + "@delonda's password:"
	var x_offset = w.length() - 1 #position the prompt based on size of history
	pass_prompt.rect_global_position = Vector2(x_offset, y_offset) * Vector2(7, 18)
	pass_prompt.rect_global_position.y += 8
	pass_prompt.rect_global_position.x += 20
	pass_prompt.show()
	pass_entry.grab_focus()
	pass_entry.text = ""

func on_login_failed(reason: String) -> void:
	match reason:
		"account":
			post_create_account()
		"password":
			post_bad_password()
