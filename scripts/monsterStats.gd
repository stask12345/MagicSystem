extends Resource
class_name MonsterStats
@export var hp : int
@export var damage : int
@export var slimeStats : MonsterStatsSlime = MonsterStatsSlime.new()
@export var coinsMin : int = 1
@export var coinsMax : int = 2
@export var experienceRank : int = 1 #exp for player, * 5
