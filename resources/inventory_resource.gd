class_name Inventory extends Resource

@export var size: int:
	set(value):
		size = value
		contents.resize(value)

var contents: Array[Item]

## adds item at specified index, or starting from first empty position if not specified
func add_item(item: Item, index: int = -1) -> void:
	if index == -1:
		for i in contents.size():
			if contents[i] == null:
				contents[i] = item
				return
	elif index >= 0 && index < contents.size():
		contents[index] = item

## removes item at specified index, or last position if not specified
func remove_item(index: int = -1) -> void:
	if index == -1:
		for i in range(contents.size() -1, -1, -1):
			if contents[i] != null:
				contents[i] = null
				return
	elif index >= 0 && index < contents.size():
		contents[index] = null

func print_contents() -> void:
	for i in contents.size():
		if contents[i] != null:
			print("position: ",i,", name: ", contents[i].item_name)
		else:
			print("position: ",i,", name: ", contents[i])
