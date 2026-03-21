extends Interactable

class_name ItemContainer

@onready var itemPositionMarkers: Array[Marker3D]
const TEST_GAMEBOX = preload("uid://bfmsp6hdnfl06")
const TEST_ITEM_1 = preload("uid://q00chojrtehd")

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
		inventory.add_item(TEST_ITEM_1)
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
				var x = TEST_GAMEBOX.instantiate()
				itemPositionMarkers[i].add_child(x)
			else:
				pass
				#itemPositionMarkers[i].get_child(0).queue_free()
				#var x = TEST_GAMEBOX.instantiate()
				#itemPositionMarkers[i].add_child(x)
		else:
			if itemPositionMarkers[i].get_child_count() > 0:
				itemPositionMarkers[i].get_child(0).queue_free()
