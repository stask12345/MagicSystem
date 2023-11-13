extends CharacterBody2D
class_name BulletMonster

@export var speed = 1000
@export var rangeOfBullet : float = 1
var damage : int

func _ready():
	timerToDestroy()

func _physics_process(delta): #unikalne dla każdego pocisku
	velocity = Vector2(speed,0).rotated(rotation)
	move_and_slide()

func timerToDestroy():
	await get_tree().create_timer(rangeOfBullet).timeout
	queue_free()

@onready var player = get_node("/root/MainScene/Game").player
func _on_area_2d_area_entered(area):
	player.character.getDamage(damage,global_position)
	$ParticlesDeath.emitting = true
	$Sprite2D.visible = false
	await $ParticlesDeath.property_list_changed
	queue_free()
