extends Camera2D

var camera_pan_speed = 20

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			position += -1*event.relative/zoom;

func _process(delta: float) -> void:
	if Input.is_action_pressed("pan_camera_up"):
		position.y -= camera_pan_speed
	if Input.is_action_pressed("pan_camera_down"):
		position.y += camera_pan_speed
	if Input.is_action_pressed("pan_camera_left"):
		position.x -= camera_pan_speed
	if Input.is_action_pressed("pan_camera_right"):
		position.x += camera_pan_speed
		
		
