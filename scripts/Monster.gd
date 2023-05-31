extends Node2D
class_name Monster
@export var stats : Resource
@onready var maxHp = stats.hp
@onready var player = %Player
@onready var hpBar = $HPBar

func reciveDamage(damage):
	stats.hp -= damage
	hpBar.updateHealthBar(stats.hp, maxHp)
	if stats.hp <= 0:
		queue_free()
