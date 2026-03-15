class_name Interactable extends Node3D
 
## Does item require charging for interaction?
@export var charged := false
## Duration needed in seconds
@export var charge_time := 2.0
## Is object `Pickable`? [u]Only works for RigidBody3D objects[/u]
@export var is_pickable := false
var picked_up := false

var highlighted

## Use this to show highlight:
#func _process(_delta: float) -> void:
	#if highlighted:
		#show outline
	#else:
		#hide outline
	
	#highlighted = false

func _interaction(_player: Player, _charged_time: float) -> void:
	print("don't forget to override interaction()")

func _highlight():
	highlighted = true
