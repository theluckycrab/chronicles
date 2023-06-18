extends TextureButton

onready var label = $Label

func set_text(t: String) -> void:
	$Label.text = t
