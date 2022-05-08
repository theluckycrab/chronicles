extends Ability

func _init():
	ability_name = "Draw Attack"

func execute(host) -> void:
	print("Swap states to draw attack")
