extends Sprite2D

var radious = Vector2(0,0) #do usunięcia w wersji 4.0 ?
var boundary = 15 #65 do poprawy w razie błedu
var drag_state = -1 #stan dragu -1 bez inputu, inne wartości to poszczególne klikniecia
var lockJoyStick = false
var remoteControl = false
var remoteControlVector = Vector2()

func getButtonPosition():
	return position + radious

var returnSpeed = 15
func _process(delta): #wracanie nie natychmiastowe po puszczeniu dla grafiki
	if drag_state == -1:
		var pos_diffrence = (Vector2(0,0) - radious) - position
		position += pos_diffrence * returnSpeed * delta

func _input(event):
	if !lockJoyStick and event is InputEventScreenDrag or (!lockJoyStick and event is InputEventScreenTouch and event.is_pressed()):
		var event_world_position = get_canvas_transform().basis_xform(event.position)
		var distance_from_center = (event_world_position - get_parent().global_position).length()
		
		if distance_from_center <= ((boundary * global_scale.x) + 180) or event.get_index() == drag_state:
			set_global_position(event_world_position - radious * global_scale)
			set_global_position(event_world_position - radious * global_scale)
			if getButtonPosition().length() > boundary:
				set_position(getButtonPosition().normalized() * boundary - radious)
			drag_state = event.get_index()
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == drag_state:
		drag_state = -1

var errorMargin = 6 #margines od którego wykrywa ruch na joysticku
func get_value():
	var buttonCenterPosition = getButtonPosition()
	if !remoteControl:
		if buttonCenterPosition.length() > errorMargin:
			return Vector2(calculatePercentValuesOfJoystick(buttonCenterPosition.x),calculatePercentValuesOfJoystick(buttonCenterPosition.y))
	if remoteControl:
		return remoteControlVector
	return Vector2(0,0)

func calculatePercentValuesOfJoystick(value):
	return value / 65
