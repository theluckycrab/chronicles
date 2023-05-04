extends Node

static func execute(who, anim):
	anim = anim.capitalize().replace(" ", "_")
	if who.has_method("emote"):
		if who.armature.animator.has_animation(anim):
			who.emote(anim, true)
