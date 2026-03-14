extends Node3D

@onready var player := $"../.."
@onready var pickupRay := %PickupRay
@onready var stateChart = %StateChart

var current_col
var is_on_object := false

func _ready() -> void:
	PickupManager.set_player(player)

func _process(_delta: float) -> void:
	is_colliding_with_pickable()
	interact()

func is_colliding_with_pickable():
	current_col = pickupRay.get_collider()
	if current_col is Pickable:
		is_on_object = true
	else:
		is_on_object = false

func interact():
	if Input.is_action_just_pressed("interact"):
		PickupManager.interact(current_col)
