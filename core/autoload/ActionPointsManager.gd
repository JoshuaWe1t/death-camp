extends Node

const TOTAL_ACTION_POINTS: int = 10
var current_action_points: int = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('ActionPointsManagere is initialized')


func reset_action_points(value: int = 10) -> void:
	current_action_points = value
