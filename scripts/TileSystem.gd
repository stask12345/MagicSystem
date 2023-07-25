extends TileMap
class_name TileSystem

var tileMaxHeight : int
var tileMaxWidth : int
var usedTiles : Array[Vector2i] = []

enum mapSizeEnum {
	small,
	normal,
	big
}

var tiles : Dictionary = {
	"grass1": Vector2i(0,0),
	"grass2": Vector2i(0,0)
}

var layers : Dictionary = {
	"ground": 0,
	"object" : 1,
	"background": 2
}

var waterPatterns = [ #First argument is ground, second water
	Vector2(1,0),Vector2(3,2),Vector2(5,4),Vector2(7,6),Vector2(9,8),Vector2(11,10),Vector2(13,12),Vector2(15,14),Vector2(17,16)
]

var grassPatterns = [18,19,20,21,22,23,24,25]

func generateWaterPattern(pos : Vector2i):
	var waterPattern = waterPatterns.pick_random()
	
	if checkIfOccupied(pos,tile_set.get_pattern(waterPattern[1]).get_size()):
		print("Unabled to set water pond!")
		return
		print("you will never see it")
	
	set_pattern(layers["ground"],pos,tile_set.get_pattern(waterPattern[0]))
	set_pattern(layers["background"],pos, tile_set.get_pattern(waterPattern[1]))
	
	var ut = tile_set.get_pattern(waterPattern[1]).get_used_cells()
	for i in ut.size():
		ut[i].x += pos.x
		ut[i].y += pos.y
	
	usedTiles.append_array(ut)
	print(ut)

func generateGrassPattern(pos : Vector2i):
	var grassPattern = grassPatterns.pick_random()
	if !checkIfEmpty(pos,tile_set.get_pattern(grassPattern).get_size()):
		print("not empty tile!")
		return
	print("success!")
	set_pattern(layers["background"],pos,tile_set.get_pattern(grassPatterns.pick_random()))

func checkIfEmpty(pos, size = Vector2i(0,0)): #check if tile is not set
	var y = size.y
	while size.x >= 0:
		while size.y >= 0:
			if get_cell_atlas_coords(layers["ground"],pos + size) != Vector2i(-1,-1) or get_cell_atlas_coords(layers["background"],pos + size) != Vector2i(-1,-1) or get_cell_atlas_coords(layers["object"],pos + size) != Vector2i(-1,-1):
				return false
			size.y -= 1
		size.x -= 1
		size.y = y
	return true

func checkIfOccupied(pos, size = Vector2i(0,0)): #returns true if occupied
	var y = size.y
	while size.x >= 0:
		while size.y >= 0:
			if usedTiles.has(Vector2i(pos.x + size.x, pos.y + size.y)):
				return true
			size.y -= 1
		size.x -= 1
		size.y = y
	return false
