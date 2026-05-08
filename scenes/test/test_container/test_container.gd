class_name ItemContainer extends Interactable

@onready var itemPositionMarkers: Array[Marker3D]

@export var inv: Inventory

func _ready() -> void:
	init_position_markers()
	sync_items()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		inv.remove_item(-1, 1)
		inv.print_contents()
		sync_items()
	if Input.is_action_just_pressed("ui_up"):
		inv.add_item(Gamebox.new("test_gamebox", Global.GAMEBOX_MODEL))
		inv.print_contents()
		sync_items()
	if Input.is_action_just_pressed("interact"):
		sync_items()
		#test()

func _interaction(_player: Player, _charged_time: float) -> void:
	inv.print_contents()
	sync_items()

func init_position_markers() -> void:
	for i in $ItemPositionMarkers.get_child_count():
		itemPositionMarkers.append($ItemPositionMarkers.get_child(i))

func sync_items():
	for i in itemPositionMarkers.size():
		if inv.contents[i] != null:
			var model = inv.contents[i].model.instantiate()
			itemPositionMarkers[i].add_child(model)
			#model.rotation.y = model.rotation.y + inv.contents[i].rotationz_needed
		else:
			var model = itemPositionMarkers[i].get_children()
			for x in model:
				x.queue_free()
			
			

#func test():
	#var x = Global.GAMEBOX_MODEL.instantiate()
	#add_child(x)
	#x.global_position = Vector3(2,2,2)
	##x.mesh = Global.GAMEBOX_MODEL
