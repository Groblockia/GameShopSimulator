extends Node

signal highlight

var player: Player

var picked_up := false
var current_object: Node3D
var pickup_distance := Vector3(0.0,-0.6,-1.0)

func set_player(_player: Player):
	player = _player

func pickup(object) -> void:
	if picked_up:
		current_object.set_collision_layer_value(5, true)
		picked_up = false
		current_object.picked_up = false
		current_object.freeze = false
		current_object.linear_velocity = current_object.linear_velocity/current_object.mass
	else:
		if object is Interactable && object.is_pickable == true:
			current_object = object
			current_object.freeze = true
			picked_up = true
			current_object.picked_up = true
			current_object.set_collision_layer_value(5, false)

func send_highlighting_event(object: Node3D) -> void:
	if object is Interactable && object.is_pickable == true:
		highlight.connect(object._highlight)
		highlight.emit()
		highlight.disconnect(object._highlight)

func _physics_process(_delta: float) -> void:
	if picked_up:
		var camera_transform = player.camera.global_transform
		current_object.global_transform = current_object.global_transform.interpolate_with(camera_transform.translated_local(pickup_distance), 0.4)
