extends CharacterBody2D
class_name Bullet

@export var homingArea = 20
@export var homingSpeed = 0.1

var currentWand : Wand
var following = false

func _ready():
	timerToDestroy()
	$HomingArea.connect("area_shape_entered",addToHomingList)
	$HomingArea.connect("area_shape_exited",removeFromHomingList)
	$HomingArea/CollisionShape2D.shape.radius = homingArea
	$HomingArea/CollisionShape2D.position.x = homingArea

var monsterToFollow : Monster
func follow():
	var distance = 999
	monsterToFollow = null
	for h in homingList:
		var d = global_position.distance_to(h.global_position)
		if d < distance:
			monsterToFollow = h
			distance = d
	await get_tree().create_timer(0.5).timeout
	follow()

func _physics_process(delta): #unikalne dla każdego pocisku
		velocity = Vector2(currentWand.spellSigil.spellSigilStats.speed,0).rotated(rotation)
		if monsterToFollow:
			var r = rotation_degrees
			look_at(monsterToFollow.global_position)
			print(global_position.distance_to(monsterToFollow.global_position))
			rotation_degrees = lerp(r, rotation_degrees, homingSpeed)
			homingSpeed = homingSpeed * 1.1
		move_and_slide()

func timerToDestroy():
	await get_tree().create_timer(currentWand.spellSigil.spellSigilStats.range).timeout
	queue_free()

func _on_area_2d_area_entered(area):
	var monster = area.get_parent()
	monster.reciveDamage(currentWand.getDamage(),global_position)
	$ParticlesDeath.emitting = true
	$ParticlesDeath2.emitting = true
	$Sprite2D.visible = false
	await $ParticlesDeath.property_list_changed
	queue_free()

var homingList = []
func addToHomingList(_area_rid, area, _area_shape_index, _local_shape_index):
	if area.get_parent() is Monster:
		homingList.push_back(area.get_parent())
		if !following:
			following = true
			follow()

func removeFromHomingList(_area_rid, area, _area_shape_index, _local_shape_index):
	if area.get_parent() is Monster:
		homingList.erase(area.get_parent())
