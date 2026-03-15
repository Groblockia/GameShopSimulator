class_name Pickable extends RigidBody3D
 
var highlighted

## Use this to have a highlight:
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
