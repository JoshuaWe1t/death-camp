extends Node2D

func _ready() -> void:
	# Подписываемся на сигналы, чтобы видеть реакцию системы
	EventBus.ap_changed.connect(_on_ap_changed)
	EventBus.day_ended.connect(_on_day_ended)
	EventBus.day_started.connect(_on_day_started)
	EventBus.game_finished.connect(_on_game_finished)


func _input(event: InputEvent) -> void:
	# При нажатии на ПРОБЕЛ тратим 2 ОД
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		ActionPointsManager.spend_ap(2)
		
	# При нажатии на клавишу N (Next) принудительно завершаем день
	if event is InputEventKey and event.pressed and event.keycode == KEY_N:
		Global.end_day()


# --- Функции-обработчики сигналов ---
func _on_ap_changed(new_ap: int) -> void:
	print("=> ОД изменились! Осталось: ", new_ap)


func _on_day_ended(day: int) -> void:
	print("=> Завершился день: ", day)


func _on_day_started(day: int) -> void:
	print("=> Стартовал новый день: ", day, ". ОД восстановлены.")


func _on_game_finished() -> void:
	print("=> ИГРА ОКОНЧЕНА! Прошло 30 дней.")
