class_name Player extends CharacterBody3D

@export_category("Movement")
@export var SPEED := 6.0
@export var ACCEL := 6.0
@export var DECCEL := 10.0
@export var AIR_DECCEL := 2.0
@export var JUMP_FORCE := 7.0
@export var GRAVITY := 20.0
@export_category("Positions for hand-held items")
@export var box_position := Node3D

@onready var head = $Head
@onready var stateChart = %StateChart

var input_dir: Vector2
var direction: Vector3
var prev_velocity: Vector3
var player_paused := false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _process(_delta: float) -> void:
	set_movement_direction()
	toggle_mouse()
	stateChart.set_expression_property("player_paused", player_paused)
	stateChart.send_event("pause")

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		stateChart.send_event("jump")

func is_moving() -> bool:
	return Input.get_vector("forward", "backward", "left", "right") != Vector2.ZERO

## sets direction based on input direction.
func set_movement_direction() -> void:
	input_dir = (Input.get_vector("left", "right", "forward", "backward"))
	# calculates movement direction based on input direction then rotate it by head rotation
	direction = ( (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	.rotated(Vector3.UP, head.rotation.y) )

## moves the player character based on current direction, [param speed], and [param acceleration].
func move(delta: float, speed: float, accel: float = 6.0) -> void:
	velocity.x = lerp(velocity.x, direction.x * speed, delta * accel)
	velocity.z = lerp(velocity.z, direction.z * speed, delta * accel)
	
	move_and_slide()

func toggle_mouse() -> void:
	if Input.is_action_just_pressed("toggle_mouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			player_paused = true
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			player_paused = false

#region Movement state machine
func _on_idle_state_physics_processing(delta: float) -> void:
	move(delta, 0.0, DECCEL)
	if is_moving():
		stateChart.send_event("walk")
	if !is_on_floor():
		stateChart.send_event("fall")

func _on_walking_state_physics_processing(delta: float) -> void:
	move(delta, SPEED, ACCEL)
	if !is_moving():
		stateChart.send_event("idle")
	if !is_on_floor():
		stateChart.send_event("fall")

func _on_jump_state_entered() -> void:
	velocity.y += JUMP_FORCE

func _on_jump_state_physics_processing(delta: float) -> void:
	move(delta, SPEED, AIR_DECCEL)
	velocity.y -= GRAVITY * delta
	if velocity.y <= 0:
		stateChart.send_event("fall")

func _on_fall_state_physics_processing(delta: float) -> void:
	move(delta, SPEED, AIR_DECCEL)
	velocity.y -= GRAVITY * delta
	if is_on_floor():
		if is_moving():
			stateChart.send_event("walk")
		else:
			stateChart.send_event("idle")

func _on_paused_state_entered() -> void:
	prev_velocity = velocity
	velocity = Vector3.ZERO

func _on_paused_state_exited() -> void:
	velocity = prev_velocity

#endregion
