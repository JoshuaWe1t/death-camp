extends Node

# Настройки проверок 
var min_checks_per_day: int = 3
var max_checks_per_day: int = 5
var fail_chance: float = 0.15 

var fail_reasons_ru: Array[String] = [
	"Обнаружены несоответствия в родословной",
	"Саботаж рабочего процесса",
	"Подозрительные связи с заключенными",
	"Уличен в сокрытии улик"
]

var fail_reasons_en: Array[String] = [
	"Discrepancies in the family tree discovered",
	"Workplace sabotage",
	"Suspicious connections with prisoners",
	"Found guilty of withholding evidence"
]

var lang = Global.lang

func _ready() -> void:
	EventBus.day_started.connect(_on_day_started)
	# Подписываемся на сигнал саботажа/провала
	EventBus.task_failed_or_sabotaged.connect(_on_task_failed)


func _on_day_started(day: int) -> void:
	if day == 2:
		# Триггерим появление специального табло с правилами на 2-й день
		EventBus.supervisor_arrived.emit()
		print("Superviser arrived")
	
	if day >= 2:
		_process_daily_checks()


func _process_daily_checks() -> void:
	var staff = StaffManager.staff_list
	var unchecked_staff: Array = []
	var player: StaffMember = null
	
	# 1. Фильтруем список
	for member in staff:
		if member.is_player:
			player = member
		elif not member.is_checked and not member.is_neutralized and not member.is_skipped:
			unchecked_staff.append(member)
			
	var left_unchecked: int = unchecked_staff.size()
	
	# 2. Если обычных сотрудников не осталось — супервайзер проверяет игрока
	if left_unchecked == 0:
		if player and not player.is_checked:
			_check_player(player)
		return
		
	# 3. Выбираем случайное количество сотрудников на сегодня
	var checks_today = randi_range(min_checks_per_day, max_checks_per_day)
	checks_today = min(checks_today, left_unchecked) 
	
	unchecked_staff.shuffle()
	
	# 4. Проводим проверки
	for i in range(checks_today):
		var target: StaffMember = unchecked_staff[i]
		target.is_checked = true
		
		# Определяем исход проверки
		if randf() < fail_chance:
			target.is_neutralized = true
			target.neutralization_reason = fail_reasons_ru.pick_random() if lang == "rus" else fail_reasons_en.pick_random()
			
			StaffManager.transfer_staff_to_prisoner()
	
	var remaining_after_check = left_unchecked - checks_today
	print("_process_daily_checks: ", checks_today, remaining_after_check)
	EventBus.supervisor_report.emit(checks_today, remaining_after_check)
	
	# Оповещаем список, что данные изменились
	EventBus.staff_list_updated.emit()


func _check_player(player: StaffMember) -> void:
	# Здесь логика финала игры или смертельного выбора
	print("Супервайзер добрался до игрока!")
	player.is_checked = true
	# EventBus.game_over.emit(reason) или переход на сцену поражения


func _on_task_failed(skip_amount: int) -> void:
	var staff = StaffManager.staff_list
	var skipped_count = 0
	
	# Идем по списку и пропускаем первых попавшихся "чистых" сотрудников
	for member in staff:
		if not member.is_player and not member.is_checked and not member.is_neutralized and not member.is_skipped:
			member.is_skipped = true
			skipped_count += 1
			if skipped_count >= skip_amount:
				break
				
	print("Супервайзер пропустил ", skipped_count, " сотрудников из-за провала/саботажа.")
	EventBus.staff_list_updated.emit() # Обновляем UI
