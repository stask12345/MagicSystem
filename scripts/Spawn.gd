extends Sprite2D

func startPlayerAnim():
	get_node("/root/MainScene/Game/TileMap/Player").slowlyFall()

func endFall():
	get_node("/root/MainScene/Game/TileMap/Player").endFall()

func hideUI():
	get_node("/root/MainScene/Game/CanvasLayer").visible = false

func showUI():
	get_node("/root/MainScene/Game/CanvasLayer").visible = true
	get_node("/root/MainScene/Game/CanvasLayer").process_mode = Node.PROCESS_MODE_INHERIT
	z_index += 1
	get_node("/root/MainScene/Game/TileMap/Player/CollisionShape2D").disabled = false
