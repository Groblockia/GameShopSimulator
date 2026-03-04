extends Node3D

#@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var camera: Camera3D = $Camera3D
@onready var player: Player = get_parent()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	# camera movement
	if player.player_can_move:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * 0.005)
			camera.rotate_x(-event.relative.y * 0.005)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
