# inventory_menu.gd
extends Control
class_name InventoryMenu

signal page_changed(index: int)

@export var pages: Array[Control] = [%KeyItemsPage, %BoonsPage, %MapPage] 
@export var tab_labels: Array[Label] = []     # header labels/icons, one per page, same order

var current_index: int = 0
var is_open: bool = false

func _ready() -> void:
	visible = false
	_show_page(0)

func open() -> void:
	is_open = true
	visible = true
	_show_page(current_index)

func close() -> void:
	is_open = false
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if not is_open:
		return

	if event.is_action_pressed("inventory_close"):
		close()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("inventory_next_tab"):
		_show_page(current_index + 1)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("inventory_prev_tab"):
		_show_page(current_index - 1)
		get_viewport().set_input_as_handled()

func _show_page(index: int) -> void:
	if pages.is_empty():
		return

	current_index = wrapi(index, 0, pages.size())

	for i in pages.size():
		pages[i].visible = (i == current_index)
		if i < tab_labels.size():
			tab_labels[i].modulate = Color.WHITE if i == current_index else Color(0.6, 0.6, 0.6)

	if pages[current_index].has_method("on_page_shown"):
		pages[current_index].on_page_shown()

	page_changed.emit(current_index)
