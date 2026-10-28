extends CanvasLayer

@onready var title: Label = $Control/TextureRect/VBoxContainer/Title
@onready var description: Label = $Control/TextureRect/VBoxContainer/Description
@onready var utilize_button: TextureButton = $Control/TextureRect/HBoxContainer/UtilizeButton
@onready var cancel_button: TextureButton = $Control/TextureRect/HBoxContainer/CancelButton


var current_building_id: String = ""
var souls_yield: int = 0
var prisoners_cost: int = 0
var ap_cost: int = 0

var lang = Global.lang

func _ready() -> void:
	hide()
	EventBus.show_utilization_menu.connect(_on_show_utilization_menu)
	utilize_button.pressed.connect(_on_utilize_pressed)
	cancel_button.pressed.connect(_on_close_button_pressed)


func _on_show_utilization_menu(building_id: String) -> void:
	current_building_id = building_id
	var b_data = BuildingDatabase.get_building(building_id)
	
	if b_data.is_empty() or not b_data.get("is_restored", false):
		return # Здание не восстановлено
	
	# Настраиваем стоимость и награду в зависимости от типа здания
	match building_id:
		"death_wall":
			souls_yield = 15
			prisoners_cost = 15
			ap_cost = 1
			if lang == "rus":
				title.text = b_data["name"]["rus"] + " - Ресстрелять"
			else:
				title.text = b_data["name"]["eng"] + " - Execute"
		"crematorium":
			souls_yield = 25
			prisoners_cost = 25
			ap_cost = 2
			if lang == "rus":
				title.text = b_data["name"]["rus"] + " - Сжечь"
			else:
				title.text = b_data["name"]["eng"] + " - Execute"
		"gas_chamber", "gas_chamber1":
			souls_yield = 40
			prisoners_cost = 40
			ap_cost = 2
			if lang == "rus":
				title.text = b_data["name"]["rus"] + " - Удушить"
			else:
				title.text = b_data["name"]["eng"] + " - Execute"
		_:
			return # Это здание не может утилизировать
			
	if lang == "rus":
		description.text = "Вы собираетесь утилизировать %d заключенных.\nПолучено душ: %d\nТребуется ОД: %d" % [prisoners_cost, souls_yield, ap_cost]
	else:
		description.text = "You are about to dispose of %d prisoners.\nSouls gained: %d\nAP required: %d" % [prisoners_cost, souls_yield, ap_cost]
	
	show()


func _on_utilize_pressed() -> void:
	if PrisonersManager.current_prisoners < prisoners_cost:
		print("Недостаточно заключенных!")
		return
		
	if not ActionPointsManager.spend_ap(ap_cost):
		return
		
	# Списываем заключенных и начисляем души
	PrisonersManager.collect_souls(souls_yield, prisoners_cost)
	print("Утилизация успешна в здании: ", current_building_id)
	
	_on_close_button_pressed()


func _on_close_button_pressed() -> void:
	hide()
	
