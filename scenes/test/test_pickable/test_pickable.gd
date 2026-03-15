extends Pickable

@onready var outline := $outline
var picked_up := false

func _process(_delta: float) -> void:
	if highlighted:
		outline.show()
	else:
		outline.hide()
	
	highlighted = false
