class_name Inventory extends Resource

@export var contents: Array[Item]

## adds item at specified index, if not, at either first(0) by default or last(1) depending on [param order]
func add_item(item: Item, index: int = -1, order: int = 0) -> void:
	if index == -1:
		if order == 0:
			for i in contents.size():
				if contents[i] == null:
					contents[i] = item
					return
		elif order == 1:
			for i in range(contents.size()-1, -1, -1):
				if contents[i] == null :
					contents[i] = item
					return
	else:
		if contents[index] == null:
			contents[index] = item


## removes item at specified index, if not, the first(0) by default or last(1) depending on [param order]
func remove_item(index: int = -1, order: int = 0) -> void:
	if index == -1:
		if order == 0:
			for i in contents.size():
				if contents[i] != null:
					contents[i] = null
					return
		elif order == 1:
			for i in range(contents.size()-1, -1, -1):
				if contents[i] != null :
					contents[i] = null
					return
	else:
		if contents[index] == null:
			contents[index] = null


## fills inventory with the same item
func fill(item: Item) -> void:
	contents.fill(item)


## transfer items [param from] to self, with an optional [param amount]
func transfer_from(from: Inventory, amount: int = 1):
	for i in amount:
		var item_from = from.contents.pop_back()
		if !contents.has(null):
			from.contents.push_back(item_from)
		else:
			contents.push_back(item_from)


func print_contents() -> void:
	print("----------- ", Time.get_time_string_from_system())
	for i in contents.size():
		if contents[i] != null:
			print("position: ",i,", name: ", contents[i].name)
		else:
			print("position: ",i,", name: ", contents[i])
	print("-----------")
