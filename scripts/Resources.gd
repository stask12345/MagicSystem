extends Node
class_name ResourceData
@export var playerData : CharacterStats
@export var mapData : MapData

func getMapProgess(map):
	return mapData.mapProgess[map]

func updateMapProgress(map,progress):
	mapData.mapProgess[map] += progress

func getPlayerCoins():
	return playerData.gold

func updatePlayerCoins(value):
	playerData.gold += value
