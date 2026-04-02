extends Interactable

class_name ItemContainer

@onready var itemPositionMarkers: Array[Marker3D]
const GAME_BOX_TEST_1 = preload("uid://dtp4i1c430w3m")

@export var inventory: Inventory

func _ready() -> void:
	init_position_markers()
	sync_items()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		inventory.remove_item()
		sync_items()
		inventory.print_contents()
	if Input.is_action_just_pressed("ui_up"):
		var x = GAME_BOX_TEST_1.instantiate()
		inventory.add_item(x)
		sync_items()
		inventory.print_contents()

func _interaction(_player: Player, _charged_time: float) -> void:
	inventory.print_contents()

func init_position_markers() -> void:
	for i in $ItemPositionMarkers.get_child_count():
		itemPositionMarkers.append($ItemPositionMarkers.get_child(i))

func sync_items():
	for i in itemPositionMarkers.size():
		if inventory.contents[i] != null:
			if itemPositionMarkers[i].get_child_count() == 0:
				var x = GAME_BOX_TEST_1.instantiate()
				itemPositionMarkers[i].add_child(x)
			else:
				pass
		else:
			if itemPositionMarkers[i].get_child_count() > 0:
				itemPositionMarkers[i].get_child(0).queue_free()
