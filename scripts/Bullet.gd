extends CharacterBody2D
class_name Bullet

@export var damage = 10
@export var range = 1
@export var speed = 1000
var destroyed = false

func _ready():
	timerToDestroy()

func _process(_delta): #unikalne dla każdego pocisku
	if !destroyed:
		velocity = Vector2(700,0).rotated(rotation)
		move_and_slide()
	if destroyed:
		$AnimationPlayer.play("destroyAnimation")

func timerToDestroy():
	await get_tree().create_timer(range).timeout
	queue_free()


func _on_area_2d_area_entered(area):
	var monster = area.get_parent()
	monster.reciveDamage(damage)
	queue_free()
