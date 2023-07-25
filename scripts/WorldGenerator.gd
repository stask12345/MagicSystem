extends TileSystem

@export var maxXPosition : int
@export var maxYPosition : int
@onready var system : GameSystem = get_node("/root/MainScene")
@export var mapSize : mapSizeEnum

func _ready():
	mapSize = mapSizeEnum.normal
	setMapSize(Vector2(20,20))
	
	randomize()
	
	setCameraBorders()
	generateGrassland()

func setMapSize(size : Vector2): #should depend on map size 
	tileMaxHeight = size[0]
	tileMaxWidth = size[1]

func setCameraBorders():
	var camera = %Camera
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = tileMaxWidth * 16 * 5
	camera.limit_bottom = tileMaxHeight * 16 * 5

func generateGrassland():
	var numberOfWaterPonds = 0
	if mapSize == mapSizeEnum.normal: #generating water ponds
		numberOfWaterPonds = 4 + randi()%3
	for i in numberOfWaterPonds:
		generateWaterPattern(Vector2i(randi()%tileMaxWidth,randi()%tileMaxHeight))
	
	var numberOfGrassPatches
	if mapSize == mapSizeEnum.normal: #generating varius sets of grass
		numberOfGrassPatches = 8 + randi()%4
	for i in numberOfGrassPatches:
		generateGrassPattern(Vector2i(randi()%tileMaxWidth,randi()%tileMaxHeight))
	
	for w in tileMaxWidth: #generating grass
		for l in tileMaxHeight:
			if checkIfEmpty(Vector2i(w,l)):
				if getChance(2): 
					set_cell(layers["ground"],Vector2i(w,l),0,tiles["grass1"])
				else:
					set_cell(layers["ground"],Vector2i(w,l),0,tiles["grass2"])
	

func getChance(propability): #return true or false #propability 10 - 1 true 9 false
	if randi()%propability == 0:
		return true
	else:
		return false

var monsterSpawn = preload("res://objects/utility/SummonMark.tscn")
var wavePopulation = 15
func generateMonsterWave(): #spawn randomly monsters
	for i in wavePopulation:
		var m = monsterSpawn.instantiate()
		add_child(m)
		m.global_position = Vector2(randi()%maxXPosition,randi()%maxYPosition)
