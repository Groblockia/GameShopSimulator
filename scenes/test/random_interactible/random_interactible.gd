extends Interactable

@onready var material = $MeshInstance3D.get_active_material(0)
@onready var outline = $outline

var state := false

func interaction(_player: Player, charged_time: float):
	if charged == true:
		if charged_time >= charge_time:
			switch_color()
	else:
		switch_color()

func start_highlight(_player: Player, _charged_time: float) -> void:
	outline.show()

func stop_highlight(_player: Player, _charged_time: float) -> void:
	outline.hide()

func switch_color():
	state = !state
	if state:
		material.albedo_color = Color(0, 1, 0) 
	else:
		material.albedo_color = Color(1, 0, 0) 
