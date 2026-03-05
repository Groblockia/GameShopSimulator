extends Node3D

@onready var player := $"../.."
@onready var interactRay := %InteractRay

var current_col
var old_col
var on_object := false
var charged_time: float

func _process(delta: float) -> void:
	highlighting()
	
	if current_col is Interactable:
		on_object = true
	else:
		on_object = false
		charged_time = 0
	
	if Input.is_action_just_pressed("interact"):
		if on_object:
			if InteractionManager.need_charging(current_col):
				return
			else:
				interact()
	
	if Input.is_action_pressed("interact"):
		if on_object:
			charged_time += delta
		#print("%.2f s" % charged_time)
		
	if Input.is_action_just_released("interact"):
		if on_object:
			if InteractionManager.need_charging(current_col):
				interact()
				on_object = false
				charged_time = 0
			else:
				return

func interact():
	InteractionManager.send_interact_event(player, current_col, charged_time)

func manage_interaction_ui():
	%InteractionContainer.position = %Camera.unproject_position(current_col.global_position)

func manage_charge_interaction_ui():
	%ChargedInteractionContainer.max_value = current_col.charge_time
	%ChargedInteractionContainer.value = charged_time
	%ChargedInteractionContainer.position = %Camera.unproject_position(current_col.global_position)

func show_interact_ui():
	if InteractionManager.is_interactable(current_col):
		# show UI for charged interaction
		if InteractionManager.need_charging(current_col):
			%ChargedInteractionContainer.show()
			manage_charge_interaction_ui()
		# show UI for normal interaction
		else:
			%InteractionContainer.show()
			manage_interaction_ui()
			# %Label.show()
			pass
	else:
		%InteractionContainer.hide()
		%ChargedInteractionContainer.hide()

func highlighting() -> void:
	show_interact_ui()
	current_col = interactRay.get_collider()
	if current_col != old_col:
		InteractionManager.send_stop_highlight_event(player, old_col, charged_time)
	InteractionManager.send_start_highlight_event(player, current_col, charged_time)
	old_col = current_col
