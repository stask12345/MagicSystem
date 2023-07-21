extends CharacterBody2D
class_name BulletMonster

@export var speed = 1000
@export var range : float = 1
var monster : Monster

func _ready():
	timerToDestroy()

func _physics_process(delta): #unikalne dla każdego pocisku
	velocity = Vector2(speed,0).rotated(rotation)
	move_and_slide()

func timerToDestroy():
	await get_tree().create_timer(range).timeout
	queue_free()


func _on_area_2d_area_entered(area):
	monster.player.character.getDamage(monster.stats.damage,global_position)
	$ParticlesDeath.emitting = true
	$Sprite2D.visible = false
	await $ParticlesDeath.property_list_changed
	queue_free()
