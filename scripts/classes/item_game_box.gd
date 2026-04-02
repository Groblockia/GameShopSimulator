class_name ItemGameBox extends Item
 
@export var mesh: MeshInstance3D

func _ready() -> void:
	var material = mesh.get_active_material(0)
	material.albedo_texture = texture
