class_name CardboardBox extends Interactable

@onready var outline := $outline

func _process(_delta: float) -> void:
	if highlighted:
		outline.show()
	else:
		outline.hide()
	
	highlighted = false
