extends Node2D

func _ready() -> void:
	MusicManager.start_playlist()
	# Подписываемся на сигналы, чтобы видеть реакцию системы
	EventBus.ap_changed.connect(_on_ap_changed)
	EventBus.day_ended.connect(_on_day_ended)
	EventBus.day_started.connect(_on_day_started)
	EventBus.game_finished.connect(_on_game_finished)
	
	Global.start_day()


func _input(event: InputEvent) -> void:
	# Проверяем, что билд отладочный, а событие — именно нажатие клавиши на клавиатуре
	if not OS.is_debug_build():
		return

	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			# F1: Тест поражения по финансам
			KEY_F1:
				FundsManager.current_funds = -50
				print("[DEBUG] Финансы установлены в отрицательное значение")

			# F2: Добавить средства
			KEY_F2:
				FundsManager.current_funds += 500
				print("[DEBUG] Добавлено +500 финансирования. Баланс:", FundsManager.current_funds)

			# F3: Завершить текущий день
			KEY_F3:
				Global.end_day()
				print("[DEBUG] Принудительное завершение дня")

			# F4: Принудительный вызов меню победы/поражения
			KEY_F4:
				EventBus.game_lost.emit("cons5")
				print("[DEBUG] Сигнал поражения cons5 отправлен")

			# F5: Сброс проверки супервайзера
			KEY_F5:
				EventBus.supervisor_reached_player.emit()
				print("[DEBUG] Сигнал проверки супервайзера отправлен")


func _on_ap_changed(new_ap: int) -> void:
	print("=> ОД изменились! Осталось: ", new_ap)


func _on_day_ended(day: int) -> void:
	print("=> Завершился день: ", day)


func _on_day_started(day: int) -> void:
	print("=> Стартовал новый день: ", day, ". ОД восстановлены.")


func _on_game_finished() -> void:
	print("=> ИГРА ОКОНЧЕНА! Прошло 30 дней.")
