extends Node3D

@onready var player := $"../.."
@onready var pickupRay := %PickupRay
@onready var stateChart = %StateChart

var current_col

func _ready() -> void:
	PickupManager.set_player(player)

func _process(_delta: float) -> void:
	current_col = pickupRay.get_collider()
	interact()
	highlighting()
	manage_ui()

func is_colliding_with_pickable() -> bool:
	if current_col is Interactable && current_col.is_pickable == true:
		return true
	else:
		return false

func interact():
	if Input.is_action_just_pressed("interact"):
		PickupManager.pickup(current_col)

func highlighting() -> void:
	PickupManager.send_highlighting_event(current_col)

func manage_ui():
	if is_colliding_with_pickable():
		%PickableInteractionContainer.show()
		show_interaction_ui()
	else:
		%PickableInteractionContainer.hide()

func show_interaction_ui():
	%PickableInteractionContainer.position = %Camera.unproject_position(current_col.global_position)
