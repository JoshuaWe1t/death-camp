extends Node

var total_prizoners: int
var current_prisoners: int = 400
var prisoners_souls: int = 0
var total_escaped_prisoners: int = 0

var global_soul_quota: int = 150
var global_souls_collected: int = 0
var is_global_quota_reached: bool = false

var is_pact_accepted: bool = false
var daily_soul_quota: int = 0
var souls_collected_today: int = 0
var quota_penalty_multiplier: float = 1.0

func _ready() -> void:
	print("PrizonersManager is initialized")
	EventBus.day_started.connect(_on_day_started)
	EventBus.day_ended.connect(_on_day_ended)
	EventBus.mysterious_offer_accepted.connect(_on_pact_accepted)


func _on_day_started(day: int) -> void:
	if day == 4 and not is_pact_accepted:
		EventBus.show_mysterious_offer.emit()
	elif is_pact_accepted and not is_global_quota_reached:
		_generate_daily_quota()


func _on_day_ended(_day: int) -> void:
	if is_pact_accepted and not is_global_quota_reached:
		if souls_collected_today < daily_soul_quota:
			# Игрок не выполнил квоту: увеличиваем множитель на следующий день
			quota_penalty_multiplier += 0.5
			print("Квота душ не выполнена! Следующая квота будет увеличена.")
			EventBus.soul_quota_failed.emit(quota_penalty_multiplier)
		else:
			# Квота выполнена, сбрасываем множитель штрафа до базового
			quota_penalty_multiplier = 1.0
			
		souls_collected_today = 0 # Сброс счетчика на следующий день


func _on_pact_accepted() -> void:
	is_pact_accepted = true
	_generate_daily_quota()


func _generate_daily_quota() -> void:
	var max_capacity = _calculate_max_soul_capacity()
	
	if max_capacity == 0:
		# Если нет зданий, просим символическое количество, чтобы вынудить строить
		daily_soul_quota = int(5 * quota_penalty_multiplier) 
	else:
		# Генерируем квоту (например, от 30% до 80% от максимальной мощности лагеря)
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var random_factor = rng.randf_range(0.3, 0.8)
		daily_soul_quota = int(max_capacity * random_factor * quota_penalty_multiplier)
		
		# Ограничиваем, чтобы квота не превышала физические возможности
		if daily_soul_quota > max_capacity:
			daily_soul_quota = max_capacity
			
	# Ежедневная квота не должна превышать остаток глобальной квоты
	var remaining_global_quota = global_soul_quota - global_souls_collected
	if daily_soul_quota > remaining_global_quota:
		daily_soul_quota = remaining_global_quota
			
	print("Новое задание по душам на сегодня: ", daily_soul_quota, " | Осталось собрать глобально: ", remaining_global_quota)
	EventBus.soul_quota_updated.emit(souls_collected_today, daily_soul_quota)


# Подсчет максимального количества душ, которое игрок может добыть за день
func _calculate_max_soul_capacity() -> int:
	var capacity = 0
	# Сверяемся с BuildingDatabase для получения актуальных данных по восстановлению
	if BuildingDatabase.get_building("death_wall").get("is_restored", false): capacity += 20
	if BuildingDatabase.get_building("gas_chamber").get("is_restored", false): capacity += 40
	if BuildingDatabase.get_building("gas_chamber1").get("is_restored", false): capacity += 40
	if BuildingDatabase.get_building("crematorium").get("is_restored", false): capacity += 25
	return capacity


func collect_souls(amount: int, prisoners_spent: int) -> void:
	current_prisoners -= prisoners_spent
	prisoners_souls += amount
	
	if is_pact_accepted and not is_global_quota_reached:
		souls_collected_today += amount
		global_souls_collected += amount
		
		EventBus.soul_quota_updated.emit(souls_collected_today, daily_soul_quota)
		
		if souls_collected_today >= daily_soul_quota:
			print("Квота душ на сегодня выполнена!")
			
		# Проверка выполнения глобальной квоты
		if global_souls_collected >= global_soul_quota:
			is_global_quota_reached = true
			print("Глобальная квота душ выполнена!")
			EventBus.global_quota_completed.emit()


func reset_prisoners_count(prisoners_count: int = 400, souls: int = 0) -> void:
	current_prisoners = prisoners_count
	prisoners_souls = souls


func can_afford_restoration(prisoners: int) -> bool:
	if prisoners <= current_prisoners:
		return true
	
	return false


func spend_resources_for_restoration(prisoners: int) -> void:
	current_prisoners -= prisoners


func free_workers(prisoners: int) -> void:
	current_prisoners += prisoners


func escaped_prisoners(prisoners: int) -> void:
	current_prisoners -= prisoners
	total_escaped_prisoners += prisoners # Учитываем новых сбежавших
	
	# Проверяем условие победы
	if total_escaped_prisoners >= 150:
		EventBus.prisoners_escaped_quota_reached.emit()
