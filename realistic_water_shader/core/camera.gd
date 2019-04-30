extends Spatial

var camera_position = Vector3()
var camera_angle = 75.0
var camera_distance = 16.0
var camera_distance_min = 8.0
var camera_distance_max = 32.0
var camera_speed = 25.0

var mouse_delta_position = Vector2()

func _input(event: InputEvent) -> void:
		
	if event is InputEventMouseMotion:
		mouse_delta_position = event.relative
	
	if event.is_action_pressed("player_zoom_in"):
		camera_distance -= 2.0
	if event.is_action_pressed("player_zoom_out"):
		camera_distance += 2.0

func _process(delta: float) -> void:
	
	var camera_aim = $Camera.get_global_transform().basis
	var camera_direction = Vector3()
	
	if Input.is_action_pressed("player_up"):
		camera_direction += camera_aim.y
	elif Input.is_action_pressed("player_down"):
		camera_direction -= camera_aim.y
	
	if Input.is_action_pressed("player_left"):
		camera_direction -= camera_aim.x
	elif Input.is_action_pressed("player_right"):
		camera_direction += camera_aim.x
		
	camera_direction = camera_direction.normalized()
	camera_direction.y = 0.0

	self.global_transform.origin +=  camera_direction * camera_speed * delta

	camera_distance = clamp(camera_distance, camera_distance_min, camera_distance_max)
	$Camera.transform.origin.y = sin(deg2rad(camera_angle)) * camera_distance
	$Camera.transform.origin.z = cos(deg2rad(camera_angle)) * camera_distance
	
	if Input.is_action_pressed("player_angle"):
		camera_angle += mouse_delta_position.y * 0.25
		camera_angle = clamp(camera_angle, 35.0, 85.0)
		$Camera.transform = $Camera.transform.looking_at(Vector3(0.0, 0.0, 0.0), Vector3(0.0, 1.0, 0.0))
		self.rotate_y(-mouse_delta_position.x * 0.01)
	
	mouse_delta_position = Vector2()	
	