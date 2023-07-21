extends TileMap

var maxLenght = 20
var maxWidth = 20
@export var maxXPosition : int
@export var maxYPosition : int
@onready var system : GameSystem = get_node("/root/MainScene")

func _ready():
	randomize()
	setCameraBorders()
	#generateGrassland() 

func setCameraBorders():
	var camera = %Camera
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = maxXPosition
	camera.limit_bottom = maxYPosition

func generateGrassland():
	for w in maxWidth:
		for l in maxLenght:
			set_cell(0,Vector2i(w,l),0,Vector2i(0,0))
			if getChance(10):
				set_cell(0,Vector2i(w,l),0,Vector2i(randi()%4,randi()%2))

func getChance(propability):
	if randi()%propability == 0:
		return true
	else:
		return false

var monsterSpawn = preload("res://objects/utility/SummonMark.tscn")
var wavePopulation = 15
func generateMonsterWave():
	for i in wavePopulation:
		var m = monsterSpawn.instantiate()
		add_child(m)
		m.global_position = Vector2(randi()%maxXPosition,randi()%maxYPosition)
