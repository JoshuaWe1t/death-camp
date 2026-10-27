extends Node


signal edict_generated(task: Dictionary) # Когда указ пришел от руководства
signal edict_accepted(task: Dictionary)  # Когда игрок нажал "Выполнить" (начал работу)
signal edict_refused(task: Dictionary)   # Когда игрок сразу отказался
signal edict_completed(task: Dictionary) # Когда игрок успешно завершил указ
signal edict_failed(task: Dictionary)    # Когда время вышло или условия не выполнены
signal edict_updated(task: Dictionary)   # Вызывается при изменении прогресса задания

const MAIN_QUEST_ID = "main_quest_restore_buildings"

var edicts_data = {}
var active_edicts = {} 
var supervisor_list_position: int = 30
var unrestored_count: int

var lang = "eng"

func _ready():
	load_edicts_data("res://core/utils/edicts_data.json")
	
	EventBus.day_started.connect(_on_day_started)
	EventBus.building_restored.connect(_on_building_restored)
	EventBus.research_completed.connect(_on_research_completed)
	
	call_deferred("_init_main_quest")


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
	var valid_edicts = []
	
	# Фильтруем указы по статусу требуемых зданий
	for edict in edicts_data["edicts"]:
		if edict.has("required_buildings"):
			var is_available = false
			for req_building in edict["required_buildings"]:
				var building_data = BuildingDatabase.get_building(req_building)
				if not building_data.is_empty() and building_data.get("is_restored", false):
					is_available = true
					break
			if is_available:
				valid_edicts.append(edict)
		else:
			valid_edicts.append(edict)
			
	if valid_edicts.is_empty():
		push_warning("Нет доступных указов для генерации (требуемые здания не восстановлены)!")
		return {}

	# Перемешиваем доступные указы, чтобы проверять их в случайном порядке
	valid_edicts.shuffle()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var selected_edict: Dictionary = {}
	var selected_target: Dictionary = {}
	var prod_type: String
	
	for edict_template in valid_edicts:
		prod_type = edict_template["production_type"]
		var available_productions = edicts_data["productions"][prod_type].duplicate()
		
		# Фильтруем доступные цели (productions) от дубликатов и уже выполненных
		for i in range(available_productions.size() - 1, -1, -1):
			var target_id = available_productions[i]["id"]
			var is_invalid = false
			
			# 1. Проверяем, есть ли уже это задание среди активных
			for task_key in active_edicts:
				if active_edicts[task_key].has("target_id") and active_edicts[task_key]["target_id"] == target_id:
					is_invalid = true
					break
			
			# 2. Если это задание на здание, проверяем, не восстановлено ли оно уже 
			if not is_invalid and prod_type == "building":
				var b_data = BuildingDatabase.get_building(target_id)
				if b_data.is_empty() or b_data.get("is_restored", false):
					is_invalid = true
			
			if is_invalid:
				available_productions.remove_at(i)
				
		# Если после фильтрации остались доступные цели, выбираем этот указ
		if not available_productions.is_empty():
			selected_edict = edict_template
			selected_target = available_productions[rng.randi_range(0, available_productions.size() - 1)]
			break
			
	if selected_edict.is_empty():
		push_warning("Нет доступных целей для генерации (все задания уже активны или выполнены)!")
		return {}
	
	prod_type = selected_edict["production_type"]
	var instance_id = str(Time.get_unix_time_from_system()) + "_" + str(rng.randi_range(1000, 9999))
	
	var edict_name: String
	var target_name: String
	
	if lang == "rus":
		edict_name = selected_edict["name"]["rus"]
		target_name = selected_target["name"]["rus"]
	else:
		edict_name = selected_edict["name"]["eng"]
		target_name = selected_target["name"]["eng"]
	
	var task = {
		"instance_id": instance_id,
		"id": selected_edict["id"] + "_" + selected_target["id"],
		"full_name": edict_name + ": " + target_name,
		"time_days": rng.randi_range(selected_edict["time_min"], selected_edict["time_max"]),
		"reward": rng.randi_range(selected_edict["reward_min"], selected_edict["reward_max"]),
		"penalty": rng.randi_range(selected_edict["penalty_min"], selected_edict["penalty_max"]),
		"supervisor_advance": rng.randi_range(selected_edict["supervisor_advance_min"], selected_edict["supervisor_advance_max"]),
		"ap_cost": rng.randi_range(selected_edict["ap_cost_min"], selected_edict["ap_cost_max"]),
		"target_id": selected_target["id"],
		"production_type": prod_type
	}
	
	if prod_type == "resource":
		task["required_quantity"] = rng.randi_range(10, 50)
		task["current_quantity"] = 0
		task["full_name"] = "Произвести " + str(task["required_quantity"]) + " ед. товара: " + target_name
	
	elif prod_type == "building":
		var building_data = BuildingDatabase.get_building(selected_target["id"])
		if not building_data.is_empty():
			# Устанавливаем время на выполнение задания равным: ВремяВосстановления + 1 день
			task["time_days"] = building_data["restore_time"] + 1

	active_edicts[instance_id] = task
	edict_generated.emit(task)
	return task


func accept_edict(instance_id: String):
	if not active_edicts.has(instance_id):
		return

	var task = active_edicts[instance_id]
	var ap_left = ActionPointsManager.current_action_points - task.get("ap_cost")
	EventBus.ap_changed.emit(ap_left)

	print("Указ принят в работу: ", task["full_name"])

	# Оповещаем другие системы (например, HUD для отображения таймера)
	edict_accepted.emit(task)


func complete_edict(instance_id: String):
	if not active_edicts.has(instance_id):
		return
		
	var task = active_edicts[instance_id]
	
	# Используем .get() со значением по умолчанию 0, чтобы избежать краша
	var reward = task.get("reward", 0)
	FundsManager.current_funds += reward
	
	print("Указ выполнен успешно! Получено финансирование: ", reward, " ус. ед.")
	print("Текущий баланс: ", FundsManager.current_funds)
	edict_completed.emit(task)
	
	active_edicts.erase(instance_id)


func refuse_edict(instance_id: String):
	if instance_id == MAIN_QUEST_ID:
		return
	
	if not active_edicts.has(instance_id):
		return
		
	var task = active_edicts[instance_id]
	print("Игрок ОТКАЗАЛСЯ от выполнения указа: ", task["full_name"])
	
	_apply_edict_penalty(task)
	edict_refused.emit(task)
	active_edicts.erase(instance_id)
	EventBus.task_failed_or_sabotaged.emit(task.get("supervisor_advance"))


func fail_edict(instance_id: String):
	if instance_id == MAIN_QUEST_ID:
		return
		
	if not active_edicts.has(instance_id):
		return
		
	var task = active_edicts[instance_id]
	print("Указ ПРОВАЛЕН (истекло время или не выполнены условия): ", task["full_name"])
	
	_apply_edict_penalty(task)
	edict_failed.emit(task)
	active_edicts.erase(instance_id)
	EventBus.task_failed_or_sabotaged.emit(task.get("supervisor_advance"))


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


func _on_day_started(day: int) -> void:
	if day % 2 == 0:
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


func _init_main_quest() -> void:
	unrestored_count = BuildingDatabase.get_unrestored_buildings_count()
	
	if unrestored_count == 0:
		return
		
	var task = {
		"instance_id": MAIN_QUEST_ID,
		"id": "main_restore",
		"full_name": "Восстановить разрушенные здания",
		"required_quantity": unrestored_count,
		"current_quantity": 0,
		"is_main_quest": true # Флаг, чтобы отличать от обычных указов
	}
	
	active_edicts[MAIN_QUEST_ID] = task
	# Сразу имитируем принятие задания, чтобы оно появилось в HUD
	edict_accepted.emit(task)


func _on_building_restored(_building_id: String) -> void:
	# 1. Проверяем главный квест на общее количество восстановленных зданий
	if active_edicts.has(MAIN_QUEST_ID):
		add_progress_to_edict(MAIN_QUEST_ID, 1)
		
	# 2. Ищем обычные указы, привязанные к этому конкретному зданию
	var tasks_to_complete = []
	for instance_id in active_edicts:
		var task = active_edicts[instance_id]
		# Если цель задания совпадает с ID только что восстановленного здания
		if task.has("target_id") and task["target_id"] == _building_id:
			tasks_to_complete.append(instance_id)
			
	# Завершаем найденные задания (в отдельном цикле, чтобы не сломать итерацию словаря)
	for instance_id in tasks_to_complete:
		complete_edict(instance_id)


func _on_research_completed(research_id: String, research_type: String) -> void:
	var tasks_to_complete = []
	
	# Ищем активные указы, связанные с исследованиями
	for instance_id in active_edicts:
		var task = active_edicts[instance_id]
		
		# Задание может требовать конкретное исследование (target_id)
		# или любой проект определенного типа (production_type == "research" или "experiment")
		if task.has("target_id") and task["target_id"] == research_id:
			tasks_to_complete.append(instance_id)
		elif task.has("production_type") and task["production_type"] == research_type:
			# Если задание количественное
			if task.has("required_quantity"):
				add_progress_to_edict(instance_id, 1)
			else:
				tasks_to_complete.append(instance_id)
				
	# Завершаем найденные задания
	for instance_id in tasks_to_complete:
		if active_edicts.has(instance_id):
			complete_edict(instance_id)
