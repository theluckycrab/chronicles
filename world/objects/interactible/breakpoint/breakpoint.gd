extends MeshInstance

func activate(host):
	$Control.host = host
	$Control.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func animate():
	$AnimationPlayer.play("Working")
	yield(get_tree().create_timer(0.2), "timeout")
	$AnimationPlayer.play("Idle")
