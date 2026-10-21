extends Node


const TOTAL_DAYS: int = 30
var current_day: int = 1


func _ready() -> void:
	print("Global is initialized")
	# Опционально: автоматический старт первого дня при запуске игры
	call_deferred("start_day")


func start_day() -> void:
	print("День ", current_day, " начался.")
	EventBus.day_started.emit(current_day)


func end_day() -> void:
	EventBus.day_ended.emit(current_day)
	
	if current_day < TOTAL_DAYS:
		current_day += 1
		ActionPointsManager.reset_action_points()
		start_day()
	else:
		EventBus.game_finished.emit()
		print("Месяц завершен. Игра окончена.")
