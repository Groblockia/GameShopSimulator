extends Node

var player: Player

var picked_up = false
var current_object: Node3D
var pickup_distance = Vector3(0.0,0.0,-1.5)

func set_player(_player: Player):
	player = _player

func interact(object):
	if picked_up:
		current_object.set_collision_layer_value(5, true)
		picked_up = false
		current_object.freeze = false
		current_object.linear_velocity = current_object.linear_velocity/current_object.mass
		
	else:
		if object is Pickable:
			current_object = object
			current_object.freeze = true
			picked_up = true
			current_object.set_collision_layer_value(5, false)

func _physics_process(_delta: float) -> void:
	if picked_up:
		var camera_transform = player.camera.global_transform
		current_object.global_transform = current_object.global_transform.interpolate_with(camera_transform.translated_local(pickup_distance), 0.4)
