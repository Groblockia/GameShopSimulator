extends Node3D

@onready var player := $"../.."
@onready var interactRay := %InteractRay
@onready var stateChart = %StateChart

var current_col
var is_on_object := false
var charged_time: float

func _process(delta: float) -> void:
	is_colliding_with_interactable()
	manage_ui()
	highlighting()
	normal_interact()
	charged_interact(delta)

func is_colliding_with_interactable():
	current_col = interactRay.get_collider()
	if current_col is Interactable:
		is_on_object = true
	else:
		is_on_object = false
		charged_time = 0

func normal_interact():
	if Input.is_action_just_pressed("interact"):
		charged_time = 0
		if is_on_object:
			if InteractionManager.needs_charging(current_col):
				return
			else:
				InteractionManager.send_interact_event(player, current_col)

func charged_interact(delta: float):
	if Input.is_action_pressed("interact"):
		if is_on_object:
			charged_time += delta
	
	if Input.is_action_just_released("interact"):
		if InteractionManager.needs_charging(current_col):
			InteractionManager.send_interact_event(player, current_col, charged_time)
			charged_time = 0

func highlighting() -> void:
	InteractionManager.send_highlighting_event(player, current_col)

func manage_ui():
	if current_col is Interactable:
		if InteractionManager.needs_charging(current_col):
			%ChargedInteractionContainer.show()
			show_charged_interaction_ui()
		else:
			%InteractionContainer.show()
			show_normal_interaction_ui()
			pass
	else:
		%InteractionContainer.hide()
		%ChargedInteractionContainer.hide()

func show_normal_interaction_ui():
	%InteractionContainer.position = %Camera.unproject_position(current_col.global_position)

func show_charged_interaction_ui():
	%ChargedInteractionContainer.max_value = current_col.charge_time
	%ChargedInteractionContainer.value = charged_time
	%ChargedInteractionContainer.position = %Camera.unproject_position(current_col.global_position)
