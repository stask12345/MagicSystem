extends Resource
class_name RealmPackage
@export var monsterTier1 : Array[PackedScene]
@export var monsterTier2 : Array[PackedScene]
@export var monsterTier3 : Array[PackedScene]
@export var monsterPopulation : Array[int]
@export var numberOfMaps : int #Do I want it here?

func makeMonsterList(mapProgress, mapSize): #returns list of monster in realm / 1 argument is percent value of progress in that real / 2 argument is size of map 
	var numberOfMonsters = monsterPopulation[mapSize] #calculation number of monster
	if mapProgress < 30:
		numberOfMonsters += (randi()%(3*(mapSize+1)))
	else:
		if mapProgress >= 30 and mapProgress < 70:
			numberOfMonsters + (randi()%(5*(mapSize+1)))
		else:
			if mapProgress >= 70:
				numberOfMonsters + (randi()%(8*(mapSize+1)))
	
	var monsterTiers = [] #monster tiers
	if mapProgress < 15:
		monsterTiers.push_back({0:numberOfMonsters})
	else:
		if mapProgress > 15 and mapProgress < 30:
			var otherTiers = numberOfMonsters/4
			monsterTiers.push_back({1:(numberOfMonsters-otherTiers)})
			monsterTiers.push_back({2:otherTiers})
		else:
			if mapProgress > 30 and mapProgress < 45:
				var otherTiers = numberOfMonsters/4
				monsterTiers.push_back({2:(numberOfMonsters-otherTiers)})
				monsterTiers.push_back({1:otherTiers})
			else:
				if mapProgress > 45 and mapProgress < 60:
					monsterTiers.push_back({2:(numberOfMonsters)})
				else:
					if mapProgress > 60 and mapProgress < 75:
						var otherTiers = numberOfMonsters/4
						monsterTiers.push_back({2:(numberOfMonsters-otherTiers)})
						monsterTiers.push_back({3:otherTiers})
					else:
						if mapProgress > 75:
							monsterTiers.push_back({3:(numberOfMonsters)})
	
	var monsterList = []
	
	for monsterTierPack in monsterTiers:
		if monsterTierPack.has(1):
			for i in monsterTierPack[1]:
				monsterList.push_back(monsterTier1.pick_random())
		
		if monsterTierPack.has(2):
			for i in monsterTierPack[2]:
				monsterList.push_back(monsterTier2.pick_random())
		
		if monsterTierPack.has(3):
			for i in monsterTierPack[3]:
				monsterList.push_back(monsterTier3.pick_random())
	
	return monsterList

func getMonster(tier):
	var monsters : Array[PackedScene]
	if tier == 1:
		monsters = monsterTier1
	if tier == 2:
		monsters = monsterTier2
	if tier == 3:
		monsters = monsterTier3
	
	return monsters.pick_random()
