extends Node

var staff_list: Array = []
var available_names: Array = [] # Массив для хранения загруженных имен
var total_stuff: int
var current_stuff: int = 32
var is_skipped: bool = false
var lang = "eng"

func _ready() -> void:
	_load_names_from_json() # Загружаем имена перед генерацией
	_generate_initial_staff()
	print(staff_list)


# Новая функция для чтения файла german_names.json
func _load_names_from_json() -> void:
	# Убедитесь, что путь к файлу верный для вашего проекта
	var file = FileAccess.open("res://core/utils/german_names.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		var error = json.parse(file.get_as_text())
		if error == OK:
			available_names = json.data
		else:
			push_error("Ошибка парсинга JSON.")
	else:
		push_error("Не удалось найти файл german_names.json.")


# Вспомогательная функция для получения случайного имени
func _get_random_name() -> Dictionary:
	if available_names.size() > 0:
		return available_names.pick_random()
	# Возвращаем заглушку, если файл не загрузился
	return {"first_name_ru": "Работник", "last_name_ru": "Неизвестный"}


func _generate_initial_staff() -> void:
	staff_list.clear()
	
	# 1. Игрок всегда добавляется первым
	var player = StaffMember.new(0, true, "Имя", "Фамилия", "Управляющий")
	staff_list.append(player)
	
	# 2. Генерируем остальной штат
	for i in range(1, current_stuff):
		var role = "Охранник" if lang == "rus" else "Security"
		if i == 1: 
			role = "Администратор" if lang == "rus" else "Administrator"
			
		var name_data = _get_random_name()
		var member: StaffMember = null
		if lang == "eng":
			member = StaffMember.new(i, false, name_data["first_name_en"], name_data["last_name_en"], role)
		else:
			# Подставляем русские версии имени и фамилии
			member = StaffMember.new(i, false, name_data["first_name_ru"], name_data["last_name_ru"], role)
		staff_list.append(member)


func reset_stuff_count(value: int = 32) -> void:
	current_stuff = value
	_generate_initial_staff()


func add_new_staff(value: int) -> void:
	var start_id = staff_list.size() # Берем текущий размер массива для генерации уникальных ID
	
	for i in range(value):
		var name_data = _get_random_name()
		var role = "Охранник" if lang == "rus" else "Security"
		var member: StaffMember = null
		if lang == "eng":
			member = StaffMember.new(start_id + i, false, name_data["first_name_en"], name_data["last_name_en"], role)
		else:
			# Подставляем русские версии имени и фамилии
			member = StaffMember.new(start_id + i, false, name_data["first_name_ru"], name_data["last_name_ru"], role)
		staff_list.append(member)
		
	current_stuff += value
	EventBus.staff_list_updated.emit() 


func transfer_staff_to_prisoner() -> void:
	if current_stuff > 0:
		current_stuff -= 1
		PrisonersManager.current_prisoners += 1
		# Оповещаем HUD об изменении цифр
		EventBus.counters_updated.emit(current_stuff, PrisonersManager.current_prisoners)
