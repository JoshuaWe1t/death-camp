extends Node

var staff_list: Array = []
var total_stuff: int
var current_stuff: int = 32

func _ready() -> void:
	_generate_initial_staff()
	print(staff_list)


func _generate_initial_staff() -> void:
	staff_list.clear()
	
	# 1. Игрок всегда добавляется первым
	var player = StaffMember.new(0, true, "Имя", "Фамилия", "Управляющий")
	staff_list.append(player)
	
	# 2. Генерируем остальной штат (31 человек: 30 охранников и 1 админ, например)
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
	current_stuff += value
	# Здесь позже добавим логику генерации новых объектов при найме
