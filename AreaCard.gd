extends Sprite2D

@onready var Menu = get_node("/root/MainScene/Menu")
@export var areaData : RealmPackage
@export var progress : float = 0
@export var maxProgress : float = 0
@export var mapId : int = 0
@onready var progressBar = get_node("/root/MainScene/Menu/CanvasLayer/Center/ProgressBar/Progress")

func _ready():
	if mapId != -1:
		progress = get_node("/root/MainScene/Resources").getMapProgess(mapId)
		progressBar.scale.x = (progress/maxProgress)
	$TouchScreenButton.connect("pressed",enterArea)

var gameWorld = preload("res://Game.tscn")
func enterArea():
	playAnimation()
	await get_tree().create_timer(0.3).timeout
	
	var game = gameWorld.instantiate()
	get_node("/root/MainScene").add_child(game)
	
	if mapId != -1:
		call_deferred("generateRealm")
	
	Menu.queue_free()

func playAnimation():
	
	var t = get_tree().create_tween()
	t.set_ease(Tween.EASE_IN)
	t.set_trans(Tween.TRANS_QUAD)
	t.tween_property(self,"scale",Vector2(2.15,2.15),0.1)
	t.tween_property(self,"scale",Vector2(2,2),0.2)


func generateRealm():
	var tilemap : WorldGenerator = get_node("/root/MainScene/Game/TileMap")
	var mapSize = randi()%3
	tilemap.mapSize = mapSize
	
	if areaData.realmName == "Forest":
		tilemap.generateGrassland()
	
	var game : GameSystem = get_node("/root/MainScene/Game")
	game.currentMapId = mapId
	game.maxWaves = areaData.getNumberOfWaves(progress/maxProgress,mapSize)
	game.timeToNewWave = areaData.getWaveTime(game.maxWaves,mapSize,progress/maxProgress)
	for i in game.maxWaves+1:
		game.monsterLists.append(areaData.makeMonsterList(progress/maxProgress,mapSize))
	game.startWaveTimer()
