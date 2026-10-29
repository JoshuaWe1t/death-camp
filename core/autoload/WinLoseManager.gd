extends Node

var is_game_over: bool = false
var lang: String = Global.lang


func _ready() -> void:
	# События победы
	EventBus.global_quota_completed.connect(_on_global_quota_completed)
	EventBus.building_restored.connect(_on_building_restored)
	EventBus.prisoners_escaped_quota_reached.connect(_on_prisoners_escaped_quota_reached)
	
	# События поражения
	EventBus.day_ended.connect(_on_day_ended)
	EventBus.supervisor_reached_player.connect(_on_supervisor_reached_player)
	EventBus.funds_changed.connect(_on_funds_changed)


func win(reason: String) -> void:
	if is_game_over: 
		return
	is_game_over = true
	print("ПОБЕДА! Причина: ", reason)
	EventBus.game_won.emit(reason)


func lose(reason: String) -> void:
	if is_game_over: 
		return
	is_game_over = true
	print("ПОРАЖЕНИЕ! Причина: ", reason)
	EventBus.game_lost.emit(reason)


func _on_global_quota_completed() -> void:
	print("Собрана полная квота душ.")
	win("cons1")


func _on_building_restored(_building_id: String) -> void:
	# Если не осталось невосстановленных зданий, игрок побеждает
	if BuildingDatabase.get_unrestored_buildings_count() == 0:
		print("Все здания восстановлены, супервайзер не успел.")
		win("cons2")


func _on_supervisor_reached_player() -> void:
	print("Супервайзер добрался до игрока.")
	lose("cons3")


func _on_funds_changed(new_amount: int) -> void:
	if new_amount <= 0:
		print("Закончилось финансирование.")
		lose("cons4")


func _on_day_ended(day: int) -> void:
	# Проверяем лимит дней (TOTAL_DAYS) из Global
	if day >= Global.TOTAL_DAYS:
		if BuildingDatabase.get_unrestored_buildings_count() > 0:
			print("Время вышло: дни закончились, а здания не были восстановлены.")
			lose("cons5")


func _on_prisoners_escaped_quota_reached() -> void:
	print("Спасен 150-й заключенный! Запущена концовка побега.")
	win("cons6") # Можно использовать любой новый ID концовки, например "cons6"
