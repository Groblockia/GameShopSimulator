extends Control

@export var text: String
@export var max_value: float
@export var value: float


func _process(_delta: float) -> void:
	%Label.text = text
	%ProgressBar.max_value = max_value
	%ProgressBar.value = value
