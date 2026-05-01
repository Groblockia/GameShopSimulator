extends Node3D

@onready var player := $"../.."
@onready var pickupRay := %PickupRay
@onready var stateChart = %StateChart
@onready var interactionComponent = %InteractionComponent

var current_col
var object_in_hand
var hands_full: bool

func _ready() -> void:
	PickupManager.set_player(player)

func _process(_delta: float) -> void:
	current_col = pickupRay.get_collider()

func is_colliding_with_pickable() -> bool:
	if current_col is Interactable && current_col.is_pickable == true:
		return true
	else:
		return false

func interact():
	if Input.is_action_just_pressed("interact"):
		var x = PickupManager.pickup(current_col)
		if x == true:
			stateChart.send_event("pick_up")
		else:
			stateChart.send_event("drop")

func highlighting() -> void:
	PickupManager.send_highlighting_event(current_col)

func manage_ui():
	if is_colliding_with_pickable():
		%PickableInteractionContainer.show()
		show_interaction_ui()
	else:
		%PickableInteractionContainer.hide()

func hide_ui():
	%PickableInteractionContainer.hide()

func show_interaction_ui():
	%PickableInteractionContainer.position = %Camera.unproject_position(current_col.global_position)

func _on_hands_free_state_processing(_delta: float) -> void:
	manage_ui()
	highlighting()
	interact()

func _on_hands_free_state_exited() -> void:
	hands_full = true
	hide_ui()
	object_in_hand = current_col

func _on_hands_full_state_processing(_delta: float) -> void:
	if interactionComponent.is_looking == true:
		pass
	else:
		interact()

func _on_hands_full_state_exited() -> void:
	hands_full = false
	object_in_hand = null
