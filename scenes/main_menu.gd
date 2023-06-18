extends Spatial

onready var start_button = $Control/HBoxContainer/VBoxContainer/StartButton
onready var feedback_button = $Control/HBoxContainer/VBoxContainer/Feedback
onready var options_button = $Control/HBoxContainer/VBoxContainer/OptionsButton
onready var exit_button = $Control/HBoxContainer/VBoxContainer/ExitButton
onready var feedback_form = $Control/FeedbackForm
onready var feedback_form_text = $Control/FeedbackForm/VBoxContainer/TextEdit
onready var feedback_submit_button = $Control/FeedbackForm/VBoxContainer/HBoxContainer/SubmitButton
onready var feedback_nevermind_button = $Control/FeedbackForm/VBoxContainer/HBoxContainer/NevermindButton

func _ready():
	start_button.connect("button_down", self, "on_start")
	feedback_button.connect("button_down", self, "on_feedback")
	options_button.connect("button_down", self, "on_options")
	exit_button.connect("button_down", self, "on_exit")
	feedback_submit_button.connect("button_down", self, "on_feedback_submit")
	feedback_nevermind_button.connect("button_down", self, "on_feedback_nevermind")
	
func on_start():
	Events.emit_signal("scene_change_request", "character_select")
	pass
	
func on_feedback():
	feedback_form.show()
	exit_button.hide()
	$Control/VersionLabel.hide()
	pass
	
func on_options():
	$Control/OptionsMenu.show()
	pass
	
func on_exit():
	get_tree().quit()
	pass
	
func on_feedback_submit():
	var data = {"content":feedback_form_text.text}
	feedback_form_text.text = ""
	feedback_form.hide()
	exit_button.show()
	var request = HTTPRequest.new()
	var url = "https://discord.com/api/webhooks/1119887863132213268/FFLIW7X7n0GpgIKfgGu5LX4e8Cku3yhA1-dkRbJj_FqbqV9B5QjgbUFWvXwCHJ3nMBuy"
	var headers = ["Accept: application/json", "Content-Type:application/json"]
	data = to_json(data)
	add_child(request)
	request.connect("request_completed", self, "on_feedback_response", [request])
	request.request(url, headers, true, HTTPClient.METHOD_POST, data)
	pass
	
func on_feedback_response(a, b, c, d, e):
	e.queue_free()
	
func on_feedback_nevermind():
	feedback_form_text = ""
	feedback_form.hide()
	exit_button.show()
	pass
