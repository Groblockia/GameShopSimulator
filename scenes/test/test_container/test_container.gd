extends Interactable

class_name ItemContainer

@onready var itemPositionMarkers: Array[Marker3D]

@export var inv: Inventory

func _ready() -> void:
	init_position_markers()
	#sync_items()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		inv.remove_item(-1, 1)
		inv.print_contents()
	if Input.is_action_just_pressed("ui_up"):
		inv.add_item(Gamebox.new("test_gamebox", Global.GAMEBOX_MODEL))
		#inv.add_item(Item.new("caca"), -1, 0)
		inv.print_contents()
	if Input.is_action_just_pressed("interact"):
		test()

func _interaction(_player: Player, _charged_time: float) -> void:
	inv.print_contents()

func init_position_markers() -> void:
	for i in $ItemPositionMarkers.get_child_count():
		itemPositionMarkers.append($ItemPositionMarkers.get_child(i))

#func sync_items():
	#for i in itemPositionMarkers.size():
		#if inventory.contents[i] != null:
			#if itemPositionMarkers[i].get_child_count() == 0:
				#var x = GAME_BOX_TEST_1.instantiate()
				#itemPositionMarkers[i].add_child(x)
			#else:
				#pass
		#else:
			#if itemPositionMarkers[i].get_child_count() > 0:
				#itemPositionMarkers[i].get_child(0).queue_free()

func test():
	var x = Global.GAMEBOX_SCENE.instantiate()
	add_child(x)
	x.global_position = Vector3(2,2,2)
	#x.mesh = Global.GAMEBOX_MODEL
