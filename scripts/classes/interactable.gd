class_name Interactable extends Node3D
 
## does item require charged interaction?
@export var charged := false
## duration in seconds
@export var charge_time := 2.0

var highlighted

## Use this to have a highlight:
#func _process(_delta: float) -> void:
	#if highlighted:
		#show outline
	#else:
		#hide outline
	
	#highlighted = false

func interaction(_player: Player, _charged_time: float) -> void:
	print("don't forget to override interaction()")

func highlight(_player: Player):
	highlighted = true
