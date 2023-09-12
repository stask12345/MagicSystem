extends Node2D

@export var monster : PackedScene

@onready var system = get_node("/root/MainScene/Game")

func summonMonster():
	var m : Monster = monster.instantiate()
	get_parent().add_child(m)
	m.global_position = global_position
	system.monstersOnMap.push_back(m)

func relocate(_area_rid, area, _area_shape_index, _local_shape_index): #if position is unavailble
	var tileMap = get_node("/root/MainScene/Game/TileMap")
	global_position = Vector2(randi()%tileMap.maxXPosition,randi()%tileMap.maxYPosition)
	print("relocation")
