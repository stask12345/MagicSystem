extends Resource
class_name Wand
@export var textureWand : Texture2D
@export var damageMin : int = 0
@export var damageMax : int = 0
@export var rank : int = 0
@export var spellSigil : Sigil
@export var sigils : Array[Sigil]

func getDamage():
	var damage = damageMin + randi()%(damageMax-damageMin)
	return damage
