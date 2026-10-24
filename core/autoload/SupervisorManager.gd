extends Node

# Настройки проверок 
var min_checks_per_day: int = 3
var max_checks_per_day: int = 5
var fail_chance: float = 0.2 # Шанс провала проверки (20%)

var fail_reasons: Array[String] = [
	"Обнаружены несоответствия в родословной",
	"Саботаж рабочего процесса",
	"Подозрительные связи с заключенными",
	"Уличен в сокрытии улик"
]


func _ready() -> void:
	# Подписываемся на старт нового дня из Global/EventBus
	EventBus.day_started.connect(_on_day_started)


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
	
	# 1. Фильтруем список: отделяем игрока и находим всех непроверенных
	for member in staff:
		if member.is_player:
			player = member
		elif not member.is_checked and not member.is_neutralized:
			unchecked_staff.append(member)
			
	var left_unchecked: int = unchecked_staff.size()
	
	# 2. Если обычных сотрудников не осталось — супервайзер проверяет игрока
	if left_unchecked == 0:
		if player and not player.is_checked:
			_check_player(player)
		return
		
	# 3. Выбираем случайное количество сотрудников на сегодня
	var checks_today = randi_range(min_checks_per_day, max_checks_per_day)
	checks_today = min(checks_today, left_unchecked) # Защита, если людей меньше, чем квота
	
	# Перемешиваем массив, чтобы выбрать случайных
	unchecked_staff.shuffle()
	
	# 4. Проводим проверки
	for i in range(checks_today):
		var target: StaffMember = unchecked_staff[i]
		target.is_checked = true
		
		# Определяем исход проверки
		if randf() < fail_chance:
			target.is_neutralized = true
			target.neutralization_reason = fail_reasons.pick_random()
	
	# 5. Отправляем сигнал для UI, чтобы показать итоги проверки за день
	var remaining_after_check = left_unchecked - checks_today
	EventBus.supervisor_report.emit(checks_today, remaining_after_check)


func _check_player(player: StaffMember) -> void:
	# Здесь логика финала игры или смертельного выбора
	print("Супервайзер добрался до игрока!")
	player.is_checked = true
	# EventBus.game_over.emit(reason) или переход на сцену поражения
