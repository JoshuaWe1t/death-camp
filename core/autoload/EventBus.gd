extends Node


func _ready() -> void:
	print("EventBus is initialized")


@warning_ignore("unused_signal")
signal day_started(current_day: int)
@warning_ignore("unused_signal")
signal day_ended(current_day: int)
@warning_ignore("unused_signal")
signal ap_changed(current_ap: int)
@warning_ignore("unused_signal")
signal game_finished
@warning_ignore("unused_signal")
signal game_started


@warning_ignore("unused_signal")
signal show_restore_popup(build_id: String)
@warning_ignore("unused_signal")
signal show_edict_popup()


@warning_ignore("unused_signal")
signal building_restored(build_id: String)

@warning_ignore("unused_signal")
signal show_experiment_menu()
@warning_ignore("unused_signal")
signal show_research_popup()
@warning_ignore("unused_signal")
signal research_started(research_id: String)
@warning_ignore("unused_signal")
signal research_completed(research_id: String, type: String)


@warning_ignore("unused_signal")
signal supervisor_arrived()
@warning_ignore("unused_signal")
signal supervisor_report(checked_amount: int, left_unchecked: int)


@warning_ignore("unused_signal")
signal show_staff_list()
@warning_ignore("unused_signal")
signal staff_list_updated()

@warning_ignore("unused_signal")
signal task_failed_or_sabotaged(skip_amount: int)


@warning_ignore("unused_signal")
signal counters_updated(staff_count: int, prisoners_count: int)


@warning_ignore("unused_signal")
signal show_notofocation_letter()


@warning_ignore("unused_signal")
signal show_escaped_popup()

# Вызов меню цеха (передается id цеха, например "workshop" или "workshop1")
@warning_ignore("unused_signal")
signal show_production_popup(workshop_id: String)
# Обновление локального склада ресурсов
@warning_ignore("unused_signal")
signal resource_stock_updated(resource_id: String, total_amount: int)
# Сигнал отправки ресурсов (вызывается из UI отправки на карете / поезде)
@warning_ignore("unused_signal")
signal resource_dispatched(resource_id: String, amount: int)
# Оповещение об успешной отправке (сколько отправлено и сколько всего учтено в задании)
@warning_ignore("unused_signal")
signal resource_dispatch_completed(resource_id: String, amount_sent: int, total_sent: int)
