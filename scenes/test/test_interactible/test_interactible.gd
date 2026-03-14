extends Interactable

@onready var material = $MeshInstance3D.get_active_material(0)
@onready var outline = $outline

var state := false

func _process(_delta: float) -> void:
	if highlighted:
		outline.show()
	else:
		outline.hide()
	highlighted = false

func interaction(_player: Player, charged_time: float):
	if charged == true:
		if charged_time >= charge_time:
			switch_color()
	else:
		switch_color()

func switch_color():
	state = !state
	if state:
		material.albedo_color = Color(0, 1, 0) 
	else:
		material.albedo_color = Color(1, 0, 0) 
