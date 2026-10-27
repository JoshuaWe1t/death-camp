extends CanvasLayer

@onready var title: Label = $Control/TextureRect/VBoxContainer/Title
@onready var description: Label = $Control/TextureRect/VBoxContainer/Description
@onready var furniture_button: TextureButton = $Control/TextureRect/VBoxContainer/HBoxContainer/FurnitureButton
@onready var clothes_button: TextureButton = $Control/TextureRect/VBoxContainer/HBoxContainer/ClothesButton
@onready var produce_btn: TextureButton = $Control/TextureRect/VBoxContainer/HBoxContainer2/ProduceBtn
@onready var cancel_button: TextureButton = $Control/TextureRect/VBoxContainer/HBoxContainer2/CancelButton


var current_selected_resource: String = ""
var lang = "eng"

func _ready() -> void:
	hide()
	
	title.text = "Меню производства" if lang == "rus" else "Manufacturing Menu"
	description.text = "Выберите ресурс, ознакомтесь с описанием и нажмите 'Произвести' для начала производства" if lang == "rus" else "Select a resource, read the description, and press 'Produce' to start production"
	EventBus.show_production_popup.connect(_on_show_popup)
	EventBus.resource_stock_updated.connect(_on_stock_updated)
	
	furniture_button.pressed.connect(_on_furniture_button_pressed)
	clothes_button.pressed.connect(_on_clothes_button_pressed)
	produce_btn.pressed.connect(_on_produce_pressed)
	cancel_button.pressed.connect(_on_cancel_button_pressed)


func _on_show_popup(_workshop_id: String) -> void:
	show()


func _select_resource(res_id: String) -> void:
	current_selected_resource = res_id
	_update_ui()


func _update_ui() -> void:
	var cfg = ResourceManager.PRODUCTION_CONFIG[current_selected_resource]
	var in_stock = ResourceManager.get_resource_count(current_selected_resource)
	
	if lang == "rus":
		description.text = "Производство: %s\nПартия: от %d до %d ед.\nНа складе: %d ед.\nРасход: %d ОД" % [
			cfg["name_rus"],
			cfg["min_yield"],
			cfg["max_yield"],
			in_stock,
			cfg["ap_cost"]
		]
	else:
		description.text = "Production: %s\nBatch: %d to %d units\nIn Stock: %d units\nCost: %d AP" % [
			cfg["name_rus"],
			cfg["min_yield"],
			cfg["max_yield"],
			in_stock,
			cfg["ap_cost"]
		]
	
	# Проверяем хватает ли очков действия
	produce_btn.disabled = ActionPointsManager.current_action_points < cfg["ap_cost"]


func _on_produce_pressed() -> void:
	var produced = ResourceManager.produce_resource(current_selected_resource)
	if produced > 0:
		_update_ui()


func _on_stock_updated(_res_id: String, _amount: int) -> void:
	if visible:
		_update_ui()


# Кнопки выбора ресурсов в UI цеха:
func _on_furniture_button_pressed() -> void:
	_select_resource("furniture")


func _on_clothes_button_pressed() -> void:
	_select_resource("clothes")


func _on_close_button_pressed() -> void:
	visible = false


func _on_cancel_button_pressed() -> void:
	hide()
	description.text = "Выберите ресурс, ознакомтесь с описанием и нажмите 'Произвести' для начала производства" if lang == "rus" else "Select a resource, read the description, and press 'Produce' to start production"
