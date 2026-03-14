extends Node

signal interact
signal highlight

func send_interact_event(sender: Player, object: Node3D, charged_time: float = 0) -> void:
	if object is Interactable:
		interact.connect(object._interaction)
		interact.emit(sender, charged_time)
		interact.disconnect(object._interaction)

func send_highlighting_event(sender: Player, object: Node3D) -> void:
	if object is Interactable:
		highlight.connect(object._highlight)
		highlight.emit(sender)
		highlight.disconnect(object._highlight)

## does [param object] needs charging to interact?
func needs_charging(object: Node3D) -> bool:
	if object is Interactable:
		if object.charged == true:
			return true
		else: 
			return false
	return false
