class_name Interactable extends Area3D
 
## does item require charged interaction?
@export var charged := false
## duration in seconds
@export var charge_time := 2.0

func interaction(_player: Player, _charged_time: float) -> void:
	print("don't forget to override interaction()")
	print("test")

func start_highlight(_player: Player, _charged_time: float) -> void:
	print("don't forget to override start_highlight()")

func stop_highlight(_player: Player, _charged_time: float) -> void:
	print("don't forget to override stop_highlight()")
