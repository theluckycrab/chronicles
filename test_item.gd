extends RigidBody

enum Slots{HEAD, CHEST, GLOVES, LEGS, BOOTS}
export(Slots) var slot := Slots.CHEST

var offset: Vector2 = Vector2.ZERO
