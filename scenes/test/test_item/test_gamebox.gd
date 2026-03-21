extends Node3D
const TEST_2 = preload("uid://s33bksihoer")
const TEST_1 = preload("uid://cta8g5rax1rgj")

func _ready() -> void:
	if randi_range(0,1) == 1:
		change_image(TEST_1)
	else:
		change_image(TEST_2)

func change_image(img):
	$MeshInstance3D.get_active_material(0).albedo_texture = img
