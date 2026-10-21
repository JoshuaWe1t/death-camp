extends TextureButton
class_name Building

# Выпадающий список в инспекторе для выбора здания
@export_enum(
	"admin", "komendant", "dormitory", "morgue", "canteen", "hospital_small", 
	"barrack", "laboratory", "workshop", "hospital_large", "crematorium", "gas_chamber", "death_wall"
)
 
var building_id: String = "barrack"

var building_name: String
var is_restored: bool

var restore_cost: int
var restore_time: int
var restore_workers: int
var restore_ap: int

var upkeep_cost: int
var upkeep_cycle_days: int

var days_since_last_upkeep: int = 0

func _ready() -> void:
	load_building_data()
	EventBus.day_ended.connect(_on_day_ended)
	update_tooltip()


# Подтягиваем данные из глобального словаря
func load_building_data() -> void:
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
	
	upkeep_cost = data["upkeep_cost"]
	upkeep_cycle_days = data["upkeep_cycle"]


func update_tooltip() -> void:
	var text = building_name + "\n\n"
	
	if is_restored:
		text += "[Статус: Доступно]\n"
		if upkeep_cycle_days > 0:
			text += "Потребление: " + str(upkeep_cost) + "$ каждые " + str(upkeep_cycle_days) + " дн."
		else:
			text += "Потребление: зависит от работы"
	else:
		text += "[Статус: Требует восстановления]\n"
		text += "Стоимость: " + str(restore_cost) + "$\n"
		text += "ОД: " + str(restore_ap) + "\n"
		text += "Рабочих: " + str(restore_workers) + " чел.\n"
		text += "Время на ремонт: " + str(restore_time) + " дн."
	
	tooltip_text = text


func _on_day_ended(day: int) -> void:
	if not is_restored:
		return
		
	# 0+ дней в диздоке означает, что здание потребляет средства только во время работы
	if upkeep_cycle_days > 0:
		days_since_last_upkeep += 1
		if days_since_last_upkeep >= upkeep_cycle_days:
			FundsManager.current_funds -= upkeep_cost
			days_since_last_upkeep = 0
			print(building_name, " потребило ", upkeep_cost, "$")
