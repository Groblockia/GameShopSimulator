extends Control

@export var text: String


func _process(_delta: float) -> void:
	%Label.text = text
