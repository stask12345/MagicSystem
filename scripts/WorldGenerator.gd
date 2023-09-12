extends TileSystem
class_name WorldGenerator

@export var maxXPosition : int
@export var maxYPosition : int
@onready var system : GameSystem = get_node("/root/MainScene/Game")
@export var mapSize : mapSizeEnum

func _ready():
	randomize()

func setMapSize(size : Vector2): #should depend on map size 
	tileMaxWidth = size[0]
	tileMaxHeight = size[1]

func setCameraBorders():
	var camera = %Camera
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = tileMaxWidth * 16 * 5
	camera.limit_bottom = tileMaxHeight * 16 * 5

func generateGrassland():
	if mapSize == mapSizeEnum.small:
		setMapSize(Vector2(18,15))
	if mapSize == mapSizeEnum.normal:
		setMapSize(Vector2(20,20))
	if mapSize == mapSizeEnum.big:
		setMapSize(Vector2(25,25))
	setUpMap() #calculate availble tiles
	setCameraBorders()
	
	var numberOfGrassPatches = 0
	var numberOfWaterPonds = 0
	var numberOfTrees = 0
	var numberOfTreePaterns = 0
	var numberOfDecoration = 0
	var numberOfChest = 0
	if mapSize == mapSizeEnum.small:
		numberOfGrassPatches = 4 + randi()%4
		numberOfWaterPonds = 1 + randi()%2
		numberOfTrees = 3 + randi()%4
		numberOfTreePaterns = 1 + randi()%2
		numberOfDecoration = 10 + randi()%8
		numberOfChest = 1 + randi()%3
	if mapSize == mapSizeEnum.normal: #generating varius sets of grass
		numberOfGrassPatches = 8 + randi()%4
		numberOfWaterPonds = 2 + randi()%3
		numberOfTrees = 5 + randi()%5
		numberOfTreePaterns = 2 + randi()%3
		numberOfDecoration = 15 + randi()%10
		numberOfChest = 2 + randi()%3
	if mapSize == mapSizeEnum.big:
		numberOfGrassPatches = 10 + randi()%4
		numberOfWaterPonds = 3 + randi()%3
		numberOfTrees = 7 + randi()%5
		numberOfTreePaterns = 3 + randi()%3
		numberOfDecoration = 18 + randi()%12
		numberOfChest = 2 + randi()%3
	
	generateSpawnPoint()
	for i in numberOfGrassPatches:
		generateGrassPattern(Vector2i(randi()%tileMaxWidth,randi()%tileMaxHeight))
	for i in numberOfWaterPonds:
		generateWaterPattern()
	generateChests(numberOfChest)
	
	for w in tileMaxWidth: #generating grass
		for l in tileMaxHeight:
			if checkIfEmpty(Vector2i(w,l)):
				var rn = randi_range(0,4)
				if rn == 0: 
					set_cell(layers["ground"],Vector2i(w,l),0,tiles["grass1"])
				else:
					if rn == 1:
						set_cell(layers["ground"],Vector2i(w,l),0,tiles["grass2"])
					else:
						if rn == 2:
							set_cell(layers["ground"],Vector2i(w,l),0,tiles["grass3"])
						else:
							set_cell(layers["ground"],Vector2i(w,l),0,tiles["grass4"])
	
	generateTrees(numberOfTrees,numberOfTreePaterns)
	
	generateDecoration(numberOfDecoration)
	setUpNavigation()

func getChance(propability): #return true or false #propability 10 - 1 true 9 false
	if randi()%propability == 0:
		return true
	else:
		return false

var monsterSpawn = preload("res://objects/utility/SummonMark.tscn")
var monsterList = []
func generateMonsterWave(): #spawn randomly monsters
	maxXPosition = tileMaxWidth * 16 * 5
	maxYPosition = tileMaxHeight * 16 * 5
	for i in monsterList.size():
		var m = monsterSpawn.instantiate()
		m.monster = monsterList[i]
		$"../Monsters".add_child(m)
		m.global_position = Vector2(randi()%maxXPosition,randi()%maxYPosition)
