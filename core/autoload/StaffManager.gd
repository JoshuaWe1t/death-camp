extends Node

var staff_list: Array = []
var total_stuff: int
var current_stuff: int = 32
@export var is_skipped: bool = false

func _ready() -> void:
	_generate_initial_staff()
	print(staff_list)


func _generate_initial_staff() -> void:
	staff_list.clear()
	
	# 1. Игрок всегда добавляется первым
	var player = StaffMember.new(0, true, "Имя", "Фамилия", "Управляющий")
	staff_list.append(player)
	
	# 2. Генерируем остальной штат
	# В будущем имена можно подтягивать из JSON файла
	for i in range(1, current_stuff):
		var role = "Охранник"
		if i == 1: 
			role = "Администратор"
			
		var member = StaffMember.new(i, false, "Работник", str(i), role)
		staff_list.append(member)


func reset_stuff_count(value: int = 32) -> void:
	current_stuff = value
	_generate_initial_staff()


func add_new_staff(value: int) -> void:
	var start_id = staff_list.size() # Берем текущий размер массива для генерации уникальных ID
	
	for i in range(value):
		# Создаем нового работника. Он не проверен, не пропущен и не нейтрализован
		var member = StaffMember.new(start_id + i, false, "Новый", "Сотрудник " + str(start_id + i), "Охранник")
		staff_list.append(member)
		
	current_stuff += value
	EventBus.staff_list_updated.emit() 


func transfer_staff_to_prisoner() -> void:
	if current_stuff > 0:
		current_stuff -= 1
		PrisonersManager.current_prisoners += 1
		# Оповещаем HUD об изменении цифр
		EventBus.counters_updated.emit(current_stuff, PrisonersManager.current_prisoners)
