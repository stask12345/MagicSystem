extends Bullet

var monsterInArea : Array = []
var homingBlacklist : Array = []
var deflections = 0

func _ready():
	super()
	$Range.connect("area_entered",addMonsterToList)

func _on_area_2d_area_entered(area):
	var monster = area.get_parent()
	if !homingBlacklist.has(monster):
		monster.reciveDamage(currentWand.getDamage(),global_position)
		var timer = $DestroyTimer
		var time = timer.time_left
		timer.stop()
		timer.wait_time = time + 0.1
		timer.start()
		
		var nearestMonster : Monster = null
		for m in monsterInArea:
			if m:
				if !homingBlacklist.has(m):
					if m != monster:
						if !nearestMonster:
							nearestMonster = m
						else:
							if global_position.distance_to(m.global_position) < global_position.distance_to(nearestMonster.global_position):
								nearestMonster = m
		
		if nearestMonster and deflections < 3:
			$HomingArea/CollisionShape2D.set_deferred("disabled",true)
			look_at(nearestMonster.global_position)
			monsterToFollow = nearestMonster
			deflections += 1
		else:
			$ParticlesDeath.emitting = true
			$Sprite2D.visible = false
			$Area2D/CollisionShape2D.set_deferred("disabled",true)
			await $ParticlesDeath.property_list_changed
			call_deferred("queue_free")
		homingBlacklist.append(monster)
		homingList.erase(monster)
		$Area2D/CollisionShape2D.set_deferred("disabled",true)
		await get_tree().create_timer(0.1).timeout
		$Area2D/CollisionShape2D.set_deferred("disabled",false)


func addMonsterToList(area):
	var monster = area.get_parent()
	monsterInArea.append(monster)

func addToHomingList(_area_rid, area, _area_shape_index, _local_shape_index):
	if area.get_parent() is Monster and area.get_parent().stats.hp > 0 and !homingBlacklist.has(area.get_parent()):
		homingList.push_back(area.get_parent())
		if !following:
			following = true
			follow()


func timerToDestroy():
	$DestroyTimer.wait_time = currentWand.spellSigil.spellSigilStats.range
	$DestroyTimer.start()
	await $DestroyTimer.timeout
	if !isDestoriedByAnim:
		$ParticlesDeath.emitting = true
		$Sprite2D.visible = false
		$Area2D/CollisionShape2D.set_deferred("disabled",true)
		await $ParticlesDeath.property_list_changed
		call_deferred("queue_free")
	else:
		$AnimationPlayer.play("deathAnimation")
