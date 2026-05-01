class_name CardboardBox extends Interactable

@onready var outline := $outline

@export var inventory: Inventory
const GAME_BOX_TEST_2 = preload("uid://yryxdagohst8")
const GAME_BOX_TEST_1 = preload("uid://dtp4i1c430w3m")

func _ready() -> void:
	randomize()
	print("before filling:")
	inventory.print_contents()
	inventory.fill(GAME_BOX_TEST_2.instantiate())
	print("after filling:")
	inventory.print_contents()

func _process(_delta: float) -> void:
	if highlighted:
		outline.show()
	else:
		outline.hide()
	
	highlighted = false
