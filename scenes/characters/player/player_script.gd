class_name Player extends CharacterBody3D

@export var SPEED := 6.0
@export var ACCEL := 6.0
@export var DECCEL := 10.0

@onready var head = $Head
@onready var stateChart = $StateChart

var input_dir: Vector2
var direction: Vector3
var player_can_move := true

func _process(_delta: float) -> void:
	set_movement_direction()

func _physics_process(_delta: float) -> void:
	pass

func _unhandled_input(_event: InputEvent) -> void:
	pass

#region custom functions
func is_moving() -> bool:
	return Input.get_vector("forward", "backward", "left", "right") != Vector2.ZERO

## sets movement direction based on input direction
func set_movement_direction() -> void:
	input_dir = (Input.get_vector("left", "right", "forward", "backward"))
	#calculate movement direction based on input direction then rotate by head rotation
	direction = ( (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	.rotated(Vector3.UP, head.rotation.y) )

## moves the player character based on input direction, speed, and acceleration
func move(delta: float, speed: float, accel: float = 6.0) -> void:
	velocity.x = lerp(velocity.x, direction.x * speed, delta * accel)
	velocity.z = lerp(velocity.z, direction.z * speed, delta * accel)
	
	move_and_slide()

func jump():
	if Input.is_action_just_pressed("jump"):
		pass

#endregion

#region Movement state machine
func _on_idle_state_physics_processing(delta: float) -> void:
	move(delta, 0.0, 10.0)
	if is_moving():
		stateChart.send_event("start_walking")

func _on_walking_state_physics_processing(delta: float) -> void:
	move(delta, SPEED, 6.0)
	if !is_moving():
		stateChart.send_event("stop_walking")

func _on_jump_state_physics_processing(_delta: float) -> void:
	pass # Replace with function body.

func _on_fall_state_physics_processing(_delta: float) -> void:
	pass # Replace with function body.

#endregion
