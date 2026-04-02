extends Node

signal highlight

var player: Player

var picked_up := false:
	set(value):
		picked_up = value
		if value == false:
			drop()

var current_object: Node3D
var pickup_distance := Vector3(0.0,-0.6,-1.0)
var pickup_lerp := 0.4

func set_player(_player: Player):
	player = _player

## returns true if object is picked up, false if object is dropped
func pickup(object) -> bool:
	if picked_up:
		current_object.set_collision_layer_value(5, true)
		picked_up = false
		current_object.picked_up = false
		current_object.freeze = false
		current_object.linear_velocity = current_object.linear_velocity/current_object.mass
		current_object.angular_velocity = current_object.angular_velocity/current_object.mass
		return false
	else:
		if object is Interactable && object.is_pickable == true:
			current_object = object
			current_object.freeze = true
			picked_up = true
			current_object.picked_up = true
			current_object.set_collision_layer_value(5, false)
			return true
		return false

func drop() -> void:
	var _camera_transform = player.camera.global_transform
	current_object.global_transform = _camera_transform.translated_local(pickup_distance)


func send_highlighting_event(object: Node3D) -> void:
	if object is Interactable && object.is_pickable == true:
		highlight.connect(object._highlight)
		highlight.emit()
		highlight.disconnect(object._highlight)

func _physics_process(_delta: float) -> void:
	if picked_up:
		var camera_transform = player.camera.global_transform
		current_object.global_transform = current_object.global_transform.interpolate_with(camera_transform.translated_local(pickup_distance), pickup_lerp)
		#var lerped_transform = current_object.global_transform.interpolate_with(camera_transform.translated_local(pickup_distance), pickup_lerp)
		#current_object.global_transform = current_object.global_transform.interpolate_with(lerped_transform, pickup_lerp)
