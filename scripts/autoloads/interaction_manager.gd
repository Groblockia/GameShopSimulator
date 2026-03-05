extends Node

signal interact
signal start_highlight
signal stop_highlight

func send_interact_event(player: Player, object: Node3D, charged_time: float) -> void:
	if object is Interactable:
		interact.connect(object.interaction)
		interact.emit(player, charged_time)
		interact.disconnect(object.interaction)

func send_start_highlight_event(player: Player, object: Node3D, charged_time: float) -> void:
	if object is Interactable:
		start_highlight.connect(object.start_highlight)
		start_highlight.emit(player, charged_time)
		start_highlight.disconnect(object.start_highlight)

func send_stop_highlight_event(player: Player, object: Node3D, charged_time: float) -> void:
	if object is Interactable:
		stop_highlight.connect(object.stop_highlight)
		stop_highlight.emit(player, charged_time)
		stop_highlight.disconnect(object.stop_highlight)

## does [param object] needs charging to interact
func need_charging(object: Node3D) -> bool:
	if object is Interactable:
		if object.charged == true:
			return true
		else: 
			return false
	return false

func is_interactable(object: Node3D) -> bool:
	if object is Interactable:
		return true
	else:
		return false
