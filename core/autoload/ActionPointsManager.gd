extends Node

const MAX_ACTION_POINTS: int = 10
var current_action_points: int = MAX_ACTION_POINTS

func spend_ap(amount: int) -> bool:
	if current_action_points >= amount:
		current_action_points -= amount
		EventBus.ap_changed.emit(current_action_points)
		return true
	
	print("Недостаточно Очков Действия!")
	return false


func reset_action_points() -> void:
	current_action_points = MAX_ACTION_POINTS
	EventBus.ap_changed.emit(current_action_points)


func can_afford_restoration(action_points: int) -> bool:
	if action_points <= current_action_points:
		return true
	
	return false


func spend_resources_for_restoration(action_points: int) -> void:
	current_action_points -= action_points
	EventBus.ap_changed.emit(current_action_points)
