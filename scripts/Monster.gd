extends Node2D
class_name Monster
@export var stats : Resource
@onready var player = %Player

func reciveDamage(damage):
	stats.hp -= damage
	if stats.hp <= 0:
		queue_free()
