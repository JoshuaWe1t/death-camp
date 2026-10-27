extends TextureButton
class_name Building

# Выпадающий список в инспекторе для выбора здания
@export_enum(
	"admin", "komendant", "dormitory", "dormitory1", "morgue", "canteen", "hospital_small", 
	"barrack", "barrack1", "barrack2", "laboratory", "laboratory1", "workshop", "workshop1",
	"hospital_large", "crematorium", "gas_chamber", "gas_chamber1", "death_wall"
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

var is_restoring: bool = false
var days_left_to_restore: int = 0

func _ready() -> void:
	load_building_data()
	
	EventBus.day_ended.connect(_on_day_ended)
	pressed.connect(_on_building_pressed)
	
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
	if is_restoring:
		text += "[Статус: В процессе восстановления]\n"
		text += "Осталось дней: " + str(days_left_to_restore)
	elif is_restored:
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


func _on_day_ended(_day: int) -> void:
	print("building._on_day_ended")
	if is_restoring:
		days_left_to_restore -= 1
		update_tooltip()
		if days_left_to_restore <= 0:
			finish_restoration()
		return 
		
	if upkeep_cycle_days > 0:
		days_since_last_upkeep += 1
		if days_since_last_upkeep >= upkeep_cycle_days:
			FundsManager.current_funds -= upkeep_cost
			days_since_last_upkeep = 0
			print(building_name, " потребило ", upkeep_cost, "$")
	
	if not is_restored:
		return


func _on_building_pressed() -> void:
	if not is_restored and not is_restoring:
		EventBus.emit_signal("show_restore_popup", self)
		print("Открытие окна восстановления, building_id: ", self)
	elif is_restored:
		print("Здание уже восстановлено. Открыть меню здания.")
		match building_id:
			"komendant":
				print("Завершаем текущий день")
				Global.end_day()
			"admin":
				print("admin")
				EventBus.show_staff_list.emit()
			"dormitory":
				print("dormitory")
			"dormitory1":
				print("dormitory1")
			"morgue":
				print("morgue")
			"canteen":
				print("canteen")
			"hospital_small":
				print("hospital_small")
				EventBus.show_research_popup.emit()
			"barrack":
				print("barrack")
				EventBus.show_escaped_popup.emit()
			"barrack1":
				print("barrack1")
				EventBus.show_escaped_popup.emit()
			"barrack2":
				print("barrack2")
				EventBus.show_escaped_popup.emit()
			"laboratory":
				print("laboratory")
				EventBus.show_experiment_menu.emit()
			"laboratory1":
				print("laboratory1")
				EventBus.show_experiment_menu.emit()
			"workshop":
				print("workshop")
			"hospital_large":
				print("hospital_large")
				EventBus.show_research_popup.emit()
			"crematorium":
				print("crematorium")
			"gas_chamber":
				print("gas_chamber")
			"gas_chamber1":
				print("gas_chamber1")
			"death_wall":
				print("death_wall")
			_:
				print("Неизвестное здание.")

func start_restoration() -> void:
	is_restoring = true
	days_left_to_restore = restore_time
	
	# Списываем ресурсы и блокируем заключенных
	FundsManager.spend_resources_for_restoration(restore_cost)
	PrisonersManager.spend_resources_for_restoration(restore_workers)
	ActionPointsManager.spend_resources_for_restoration(restore_ap)
	
	update_tooltip()
	print("Начато восстановление: ", building_name)


func finish_restoration() -> void:
	print("finish_restoration()")
	is_restoring = false
	is_restored = true
	
	EventBus.building_restored.emit(building_id)
	
	# Освобождаем рабочих
	PrisonersManager.free_workers(restore_workers)
	
	match building_id:
			"dormitory":
				print(building_name, " успешно восстановлено!")
				StaffManager.add_new_staff(10)
			"dormitory1":
				print(building_name, " успешно восстановлено!")
				StaffManager.add_new_staff(10)
			"barrack":
				print(building_name, " успешно восстановлено!")
				PrisonersManager.free_workers(100)
			"barrack1":
				print(building_name, " успешно восстановлено!")
				PrisonersManager.free_workers(100)
			"barrack2":
				print(building_name, " успешно восстановлено!")
				PrisonersManager.free_workers(100)
			_:
				print("Неизвестное здание.")

	BuildingDatabase.DATA[building_id]["is_restored"] = true
	
	update_tooltip()
