extends Node

static func execute(who, anim):
	if who.has_method("emote"):
		who.emote(anim, true)
