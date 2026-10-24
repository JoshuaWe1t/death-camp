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
signal show_restore_popup(build_id: String)
@warning_ignore("unused_signal")
signal show_edict_popup()


@warning_ignore("unused_signal")
signal building_restored(build_id: String)


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
