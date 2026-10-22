extends CanvasLayer

@onready var description: Label = $PopUp/TextureRect/VBoxContainer/Description
@onready var admit_button: TextureButton = $PopUp/TextureRect/Buttons/AdmitButton
@onready var cancel_button: TextureButton = $PopUp/TextureRect/Buttons/CancelButton


var target_building: Building = null

var text: String = ""

var building_name: String
var is_restored: bool

var restore_cost: int
var restore_time: int
var restore_workers: int
var restore_ap: int


func _ready() -> void:
	hide()
	
	EventBus.show_restore_popup.connect(_on_setup_and_show)
	
	admit_button.pressed.connect(_on_admit_button_pressed)
	cancel_button.pressed.connect(_on_cancel_button_pressed)


# Подтягиваем данные из глобального словаря
func load_building_data(building_id: String) -> void:
	var data = BuildingDatabase.get_building(building_id)
	if data.is_empty():
		push_error("Здание с ID " + building_id + " не найдено!")
		return
		
	building_name = data["name"].get("eng")
	is_restored = data["is_restored"]
	
	restore_cost = data["restore_cost"]
	restore_time = data["restore_time"]
	restore_workers = data["restore_workers"]
	restore_ap = data["restore_ap"]


func _on_setup_and_show(building: Building) -> void:
	target_building = building
	text = target_building.building_name + "\n"
	text += "[Статус: Требует восстановления]\n"
	text += "Стоимость: " + str(target_building.restore_cost) + "$\n"
	text += "ОД: " + str(target_building.restore_ap) + "\n"
	text += "Рабочих: " + str(target_building.restore_workers) + " чел.\n"
	text += "Время на ремонт: " + str(target_building.restore_time) + " дн."
	
	description.text = text
	
	# Проверяем, хватает ли ресурсов, и блокируем кнопку, если нет
	var can_afford = FundsManager.can_afford_restoration(building.restore_cost) and \
		PrisonersManager.can_afford_restoration(building.restore_workers) and \
		ActionPointsManager.can_afford_restoration(building.restore_ap)
	
	admit_button.disabled = not can_afford
	show()


func _on_admit_button_pressed() -> void:
	print("admit_button is pressed")
	if target_building and not target_building.is_restoring:
		target_building.start_restoration()
	hide()
	target_building = null


func _on_cancel_button_pressed() -> void:
	print("cancel_button is pressed")
	hide()
