extends Node


signal edict_generated(task: Dictionary) # Когда указ пришел от руководства
signal edict_accepted(task: Dictionary)  # Когда игрок нажал "Выполнить" (начал работу)
signal edict_refused(task: Dictionary)   # Когда игрок сразу отказался
signal edict_completed(task: Dictionary) # Когда игрок успешно завершил указ
signal edict_failed(task: Dictionary)    # Когда время вышло или условия не выполнены
signal edict_updated(task: Dictionary)   # Вызывается при изменении прогресса задания


var edicts_data = {}
var active_edicts = {} 
var supervisor_list_position: int = 30 # Условное расстояние супервайзера до игрока


func _ready():
	load_edicts_data("res://core/utils/edicts_data.json")
	
	EventBus.day_started.connect(_on_day_started)
	
	# Пример игрового цикла
	#var new_task = generate_random_edict()
	#print("Получен новый указ: ", new_task)
	
	# Пример 1: Игрок отказывается от задания сразу
	# refuse_edict(new_task.instance_id)
	
	# Пример 2: Игрок проваливает задание (например, вышел таймер)
	# fail_edict(new_task.instance_id)
	
	# Пример 3: Игрок успешно выполняет задание
	# complete_edict(new_task.instance_id)


func load_edicts_data(file_path: String):
	if not FileAccess.file_exists(file_path):
		push_error("Файл указов не найден: " + file_path)
		return
		
	var file = FileAccess.open(file_path, FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	
	if error == OK:
		edicts_data = json.data
	else:
		push_error("Ошибка парсинга: " + json.get_error_message())


func generate_random_edict() -> Dictionary:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var edict_template = edicts_data["edicts"][rng.randi_range(0, edicts_data["edicts"].size() - 1)]
	var prod_type = edict_template["production_type"]
	
	var available_productions = edicts_data["productions"][prod_type]
	var specific_target = available_productions[rng.randi_range(0, available_productions.size() - 1)]
	
	# Генерируем уникальный ID для конкретного экземпляра задания
	var instance_id = str(Time.get_unix_time_from_system()) + "_" + str(rng.randi_range(1000, 9999))
	
	var task = {
		"instance_id": instance_id,
		"id": edict_template["id"] + "_" + specific_target["id"],
		"full_name": edict_template["name"] + ": " + specific_target["name"],
		"time_days": rng.randi_range(edict_template["time_min"], edict_template["time_max"]),
		"reward": rng.randi_range(edict_template["reward_min"], edict_template["reward_max"]),
		"penalty": rng.randi_range(edict_template["penalty_min"], edict_template["penalty_max"]),
		"supervisor_advance": rng.randi_range(edict_template["supervisor_advance_min"], edict_template["supervisor_advance_max"]),
		"ap_cost": rng.randi_range(edict_template["ap_cost_min"], edict_template["ap_cost_max"]),
		"target_id": specific_target["id"]
	}
	
	if prod_type == "resource":
		task["required_quantity"] = rng.randi_range(10, 50)
		task["current_quantity"] = 0 # Добавляем стартовый прогресс
		task["full_name"] = "Произвести " + str(task["required_quantity"]) + " ед. товара: " + specific_target["name"]
		
	active_edicts[instance_id] = task

	# Испускаем сигнал, что появился новый указ (например, для показа POPUP-окна)
	edict_generated.emit(task)
	return task


func accept_edict(instance_id: String):
	if not active_edicts.has(instance_id):
		return

	var task = active_edicts[instance_id]
	var ap_left = ActionPointsManager.current_action_points - task.get("ap_cost")
	EventBus.ap_changed.emit(ap_left)

	print("Указ принят в работу: ", task["full_name"])

	# Оповещаем другие системы (например, HUD для отображения таймера[cite: 2])
	edict_accepted.emit(task)


func complete_edict(instance_id: String):
	if not active_edicts.has(instance_id):
		return
		
	var task = active_edicts[instance_id]
	FundsManager.current_funds += task["reward"]
	
	print("Указ выполнен успешно! Получено финансирование: ", task["reward"], " ус. ед.")
	print("Текущий баланс: ", FundsManager.current_funds)
	edict_completed.emit(task)
	
	active_edicts.erase(instance_id)


func refuse_edict(instance_id: String):
	if not active_edicts.has(instance_id):
		return
		
	var task = active_edicts[instance_id]
	print("Игрок ОТКАЗАЛСЯ от выполнения указа: ", task["full_name"])
	
	_apply_edict_penalty(task)
	edict_refused.emit(task)
	active_edicts.erase(instance_id)


func fail_edict(instance_id: String):
	if not active_edicts.has(instance_id):
		return
		
	var task = active_edicts[instance_id]
	print("Указ ПРОВАЛЕН (истекло время или не выполнены условия): ", task["full_name"])
	
	_apply_edict_penalty(task)
	edict_failed.emit(task)
	active_edicts.erase(instance_id)


func _apply_edict_penalty(task: Dictionary):
	FundsManager.current_funds -= task["penalty"]
	supervisor_list_position -= task["supervisor_advance"]
	
	print("Штраф! Потеряно финансирование: ", task["penalty"], " ус. ед.")
	print("Супервайзер продвинулся по списку на ", task["supervisor_advance"], " человек.")
	print("Осталось до проверки игрока: ", max(0, supervisor_list_position), " позиций.")
	
	if FundsManager.current_funds < 0:
		FundsManager.current_funds = 0
		print("Внимание! Финансирование исчерпано.")
		
	if supervisor_list_position <= 0:
		print("GAME OVER: Супервайзер добрался до вас.")


func _on_day_started(_day: int) -> void:
	generate_random_edict()
	EventBus.show_edict_popup.emit()


func add_progress_to_edict(instance_id: String, amount: int) -> void:
	if not active_edicts.has(instance_id):
		return
		
	var task = active_edicts[instance_id]
	if task.has("required_quantity"):
		task["current_quantity"] += amount
		
		# Оповещаем HUD об изменении цифр
		edict_updated.emit(task)
		
		# Если цель достигнута, автоматически завершаем задание
		if task["current_quantity"] >= task["required_quantity"]:
			complete_edict(instance_id)
