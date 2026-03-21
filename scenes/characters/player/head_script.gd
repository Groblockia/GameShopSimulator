extends Node3D

#@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var camera: Camera3D = $Camera
@onready var player: Player = get_parent()
var mouse_motion: Vector2

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	# camera movement
	if !player.player_paused:
		if event is InputEventMouseMotion:
			mouse_motion.x = event.relative.x
			mouse_motion.y = event.relative.y

func _physics_process(delta: float) -> void:
	if !player.player_paused:
		rotate_y(-mouse_motion.x * 0.5 * delta)
		camera.rotate_x(-mouse_motion.y * 0.5 * delta)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		
		mouse_motion = Vector2.ZERO
